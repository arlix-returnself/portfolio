#!/usr/bin/env rust-script
//! Build pipeline: content/profile.yaml + content/keymap.yaml -> web/*.html + app/assets/data/profile.json
//!
//! Chạy từ repo root: `rust-script scripts/build.rs [profile-id]`
//! Không có profile-id: build tất cả profile khai báo trong content/keymap.yaml.
//!
//! ```cargo
//! [dependencies]
//! serde = { version = "1", features = ["derive"] }
//! serde_yaml = "0.9"
//! serde_json = "1"
//! ```

use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;

// ---------------------------------------------------------------------------
// content/profile.yaml
// ---------------------------------------------------------------------------

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Meta {
    canonical_url: String,
    last_updated: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Contact {
    #[serde(rename = "type")]
    kind: String,
    icon: String,
    value: String,
    link: Option<String>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Person {
    name: String,
    default_title: String,
    contact: Vec<Contact>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Education {
    institution: String,
    degree: String,
    year: i32,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct LabelContent {
    label: String,
    content: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct SkillCategory {
    id: String,
    title: String,
    icon: String,
    items: Vec<LabelContent>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct ExperienceSection {
    heading: Option<String>,
    bullets: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Experience {
    id: String,
    title: String,
    company: String,
    date_range: String,
    intro: String,
    #[serde(default)]
    sections: Vec<ExperienceSection>,
    #[serde(default)]
    technologies: Vec<LabelContent>,
    #[serde(default)]
    project_types: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct AiAutomationCategory {
    title: String,
    bullets: Vec<String>,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct ProjectCategory {
    id: String,
    title: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Project {
    id: String,
    category: String,
    title: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    alter_title: Option<String>,
    tech: String,
    description: String,
    nda: bool,
    #[serde(default)]
    link: Option<String>,
}

impl Project {
    /// Public-facing title: the real `title` for non-NDA projects, or the
    /// mandatory `alter_title` for NDA ones. Panics if an NDA project has no
    /// alter_title, so a real name can never leak into build output by mistake.
    fn display_title(&self) -> &str {
        if self.nda {
            self.alter_title
                .as_deref()
                .unwrap_or_else(|| panic!("project '{}' has nda: true but no alter_title set", self.id))
        } else {
            &self.title
        }
    }
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct AdditionalInfo {
    label: String,
    content: String,
}

#[derive(Debug, Deserialize, Serialize, Clone)]
struct Profile {
    meta: Meta,
    person: Person,
    summary: Vec<String>,
    education: Vec<Education>,
    skills: Vec<SkillCategory>,
    experience: Vec<Experience>,
    ai_automation_expertise: Vec<AiAutomationCategory>,
    project_categories: Vec<ProjectCategory>,
    projects: Vec<Project>,
    achievements: Vec<String>,
    additional_info: Vec<AdditionalInfo>,
}

// ---------------------------------------------------------------------------
// content/keymap.yaml
// ---------------------------------------------------------------------------

#[derive(Debug, Deserialize, Clone)]
struct Seo {
    description: String,
    keywords: String,
    author: String,
}

#[derive(Debug, Deserialize, Clone)]
struct ProfileKey {
    id: String,
    title: String,
    seo: Seo,
    sections: Vec<String>,
}

#[derive(Debug, Deserialize, Clone)]
struct Keymap {
    default: String,
    profiles: Vec<ProfileKey>,
}

// ---------------------------------------------------------------------------
// Inline markdown (chỉ hỗ trợ **bold**, escape HTML) + section labels
// ---------------------------------------------------------------------------

fn render_inline(text: &str) -> String {
    let mut out = String::with_capacity(text.len());
    let mut bold = false;
    let mut chars = text.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '*' && chars.peek() == Some(&'*') {
            chars.next();
            out.push_str(if bold { "</strong>" } else { "<strong>" });
            bold = !bold;
            continue;
        }
        if c == '[' {
            let mut lookahead = chars.clone();
            let mut label = String::new();
            let mut closed_bracket = false;
            for lc in lookahead.by_ref() {
                if lc == ']' {
                    closed_bracket = true;
                    break;
                }
                label.push(lc);
            }
            if closed_bracket && lookahead.peek() == Some(&'(') {
                lookahead.next();
                let mut url = String::new();
                let mut closed_paren = false;
                for uc in lookahead.by_ref() {
                    if uc == ')' {
                        closed_paren = true;
                        break;
                    }
                    url.push(uc);
                }
                if closed_paren {
                    out.push_str(&format!("<a href=\"{url}\" target=\"_blank\" rel=\"noopener\">{label}</a>"));
                    chars = lookahead;
                    continue;
                }
            }
        }
        match c {
            '&' => out.push_str("&amp;"),
            '<' => out.push_str("&lt;"),
            '>' => out.push_str("&gt;"),
            _ => out.push(c),
        }
    }
    out
}

fn section_label(id: &str) -> &'static str {
    match id {
        "summary" => "Summary",
        "skills" => "Skills",
        "experience" => "Experience",
        "ai_automation_expertise" => "AI & Automation",
        "projects" => "Projects",
        "achievements" => "Achievements",
        "education" => "Education",
        other => panic!("Unknown section id in keymap.yaml: {other}"),
    }
}

fn section_anchor(id: &str) -> &'static str {
    match id {
        "ai_automation_expertise" => "ai-automation",
        "summary" => "summary",
        "skills" => "skills",
        "experience" => "experience",
        "projects" => "projects",
        "achievements" => "achievements",
        "education" => "education",
        other => panic!("Unknown section id in keymap.yaml: {other}"),
    }
}

// ---------------------------------------------------------------------------
// HTML section renderers
// ---------------------------------------------------------------------------

fn render_header(person: &Person, title: &str) -> String {
    let contact_items: String = person
        .contact
        .iter()
        .map(|c| {
            let content = match &c.link {
                Some(link) => {
                    let target = if c.kind == "github" || c.kind == "portfolio" {
                        " target=\"_blank\""
                    } else {
                        ""
                    };
                    format!("<a href=\"{link}\"{target}>{}</a>", render_inline(&c.value))
                }
                None => format!("<span>{}</span>", render_inline(&c.value)),
            };
            format!(
                "\n                        <div class=\"contact-item\">\n                            <span>{}</span>\n                            {content}\n                        </div>",
                c.icon
            )
        })
        .collect();

    format!(
        "\n            <header class=\"header\">\n                <div class=\"header-content\">\n                    <h1>{}</h1>\n                    <div class=\"subtitle\">{}</div>\n                    <div class=\"contact-info\">{contact_items}\n                    </div>\n                </div>\n            </header>",
        person.name, title
    )
}

fn render_navigation(sections: &[String]) -> String {
    sections
        .iter()
        .map(|id| format!("<a href=\"#{}\">{}</a>", section_anchor(id), section_label(id)))
        .collect::<Vec<_>>()
        .join("\n                ")
}

fn render_summary(summary: &[String]) -> String {
    let paragraphs: String = summary
        .iter()
        .enumerate()
        .map(|(idx, p)| {
            let style = if idx > 0 { " style=\"margin-top: 15px;\"" } else { "" };
            format!("<p{style}>{}</p>", render_inline(p))
        })
        .collect::<Vec<_>>()
        .join("\n                        ");

    format!(
        "\n                <section id=\"summary\" class=\"animate-in\">\n                    <h2>Professional Summary</h2>\n                    <div class=\"summary\">\n                        {paragraphs}\n                    </div>\n                </section>"
    )
}

fn render_skills(skills: &[SkillCategory]) -> String {
    let cards: String = skills
        .iter()
        .map(|category| {
            let items: String = category
                .items
                .iter()
                .map(|item| format!("<p><strong>{}:</strong> {}</p>", item.label, render_inline(&item.content)))
                .collect::<Vec<_>>()
                .join("\n                            ");
            format!(
                "\n                        <div class=\"skill-card\">\n                            <h3>{} {}</h3>\n                            {items}\n                        </div>",
                category.icon, category.title
            )
        })
        .collect();

    format!(
        "\n                <section id=\"skills\" class=\"animate-in\">\n                    <h2>Technical Skills</h2>\n                    <div class=\"skills-grid\">{cards}\n                    </div>\n                </section>"
    )
}

fn render_experience(experience: &[Experience]) -> String {
    let jobs: String = experience
        .iter()
        .map(|job| {
            let mut body = format!("<p>{}</p>", render_inline(&job.intro));

            for section in &job.sections {
                if let Some(heading) = &section.heading {
                    body.push_str(&format!("\n                        <p style=\"margin-top: 15px;\"><strong>{heading}:</strong></p>"));
                }
                let bullets: String = section
                    .bullets
                    .iter()
                    .map(|b| format!("<li>{}</li>", render_inline(b)))
                    .collect::<Vec<_>>()
                    .join("\n                            ");
                body.push_str(&format!(
                    "\n                        <ul>\n                            {bullets}\n                        </ul>"
                ));
            }

            if !job.technologies.is_empty() {
                let tech: String = job
                    .technologies
                    .iter()
                    .map(|t| format!("{}: {}", t.label, render_inline(&t.content)))
                    .collect::<Vec<_>>()
                    .join(" &middot; ");
                body.push_str(&format!(
                    "\n                        <p style=\"margin-top: 10px;\"><strong>Technologies:</strong> {tech}</p>"
                ));
            }

            if !job.project_types.is_empty() {
                let bullets: String = job
                    .project_types
                    .iter()
                    .map(|b| format!("<li>{}</li>", render_inline(b)))
                    .collect::<Vec<_>>()
                    .join("\n                            ");
                body.push_str(&format!(
                    "\n                        <p style=\"margin-top: 15px;\"><strong>Project Types:</strong></p>\n                        <ul>\n                            {bullets}\n                        </ul>"
                ));
            }

            format!(
                "\n                    <div class=\"experience-item\">\n                        <div class=\"job-title\">{}</div>\n                        <div class=\"company-date\">{} | {}</div>\n                        {body}\n                    </div>",
                job.title, job.company, job.date_range
            )
        })
        .collect();

    format!(
        "\n                <section id=\"experience\" class=\"animate-in\">\n                    <h2>Professional Experience</h2>{jobs}\n                </section>"
    )
}

fn render_ai_automation(categories: &[AiAutomationCategory]) -> String {
    let blocks: String = categories
        .iter()
        .map(|category| {
            let bullets: String = category
                .bullets
                .iter()
                .map(|b| format!("<li>{}</li>", render_inline(b)))
                .collect::<Vec<_>>()
                .join("\n                            ");
            format!(
                "\n                    <div class=\"experience-item\">\n                        <div class=\"job-title\">{}</div>\n                        <ul>\n                            {bullets}\n                        </ul>\n                    </div>",
                category.title
            )
        })
        .collect();

    format!(
        "\n                <section id=\"ai-automation\" class=\"animate-in\">\n                    <h2>AI &amp; Automation Expertise</h2>{blocks}\n                </section>"
    )
}

fn render_project_card(project: &Project) -> String {
    let nda_badge = if project.nda {
        "<span class=\"nda-badge\" title=\"Project details restricted under NDA\" style=\"\n        display: inline-block;\n        font-size: 11px;\n        font-weight: 600;\n        color: #92400e;\n        background: #fef3c7;\n        border: 1px solid #f59e0b;\n        border-radius: 4px;\n        padding: 1px 7px;\n        margin-left: 8px;\n        vertical-align: middle;\n        letter-spacing: 0.03em;\n      \">NDA</span>"
    } else {
        ""
    };
    let nda_class = if project.nda { " nda-project" } else { "" };

    let link_html = match &project.link {
        Some(link) if !project.nda => format!(
            "\n                            <div class=\"project-link\"><a href=\"{link}\" target=\"_blank\" rel=\"noopener\">🔗 Visit site</a></div>"
        ),
        _ => String::new(),
    };

    format!(
        "\n                        <div class=\"project-card{nda_class}\">\n                            <div class=\"project-title\">{}{nda_badge}</div>\n                            <div class=\"project-tech\">{}</div>\n                            <div class=\"project-description\">\n                                {}\n                            </div>{link_html}\n                        </div>",
        project.display_title(), project.tech, render_inline(&project.description)
    )
}

fn render_projects(categories: &[ProjectCategory], projects: &[Project]) -> String {
    let mut html = String::new();
    for (idx, category) in categories.iter().enumerate() {
        let items: Vec<&Project> = projects.iter().filter(|p| p.category == category.id).collect();
        if items.is_empty() {
            continue;
        }
        let margin = if idx == 0 { "" } else { " style=\"margin-top: 40px;\"" };
        let cards: String = items.iter().map(|p| render_project_card(p)).collect();
        html.push_str(&format!(
            "\n                    <h3{margin}>{}</h3>\n                    <div class=\"projects-grid\">{cards}\n                    </div>",
            category.title
        ));
    }

    format!(
        "\n                <section id=\"projects\" class=\"animate-in\">\n                    <h2>Featured Projects</h2>{html}\n                </section>"
    )
}

fn render_achievements(achievements: &[String]) -> String {
    let bullets: String = achievements
        .iter()
        .map(|a| format!("<li>{}</li>", render_inline(a)))
        .collect::<Vec<_>>()
        .join("\n                            ");

    format!(
        "\n                <section id=\"achievements\" class=\"animate-in\">\n                    <h2>Key Achievements</h2>\n                    <div class=\"experience-item\">\n                        <ul>\n                            {bullets}\n                        </ul>\n                    </div>\n                </section>"
    )
}

fn render_education(education: &[Education]) -> String {
    let items: String = education
        .iter()
        .map(|e| {
            format!(
                "\n                    <div class=\"education-item\">\n                        <div class=\"degree\">{}, {}</div>\n                        <div class=\"institution\">{}</div>\n                    </div>",
                e.degree, e.year, e.institution
            )
        })
        .collect();

    format!("\n                <section id=\"education\" class=\"animate-in\">\n                    <h2>Education</h2>{items}\n                </section>")
}

fn render_section(id: &str, profile: &Profile) -> String {
    match id {
        "summary" => render_summary(&profile.summary),
        "skills" => render_skills(&profile.skills),
        "experience" => render_experience(&profile.experience),
        "ai_automation_expertise" => render_ai_automation(&profile.ai_automation_expertise),
        "projects" => render_projects(&profile.project_categories, &profile.projects),
        "achievements" => render_achievements(&profile.achievements),
        "education" => render_education(&profile.education),
        other => panic!("Unknown section id in keymap.yaml: {other}"),
    }
}

// ---------------------------------------------------------------------------
// Page assembly
// ---------------------------------------------------------------------------

fn build_page(profile: &Profile, key: &ProfileKey, template: &str) -> String {
    let header = render_header(&profile.person, &key.title);
    let nav = render_navigation(&key.sections);
    let sections: String = key.sections.iter().map(|id| render_section(id, profile)).collect();

    let content = format!(
        "{header}\n\n            <!-- Main Content -->\n            <div class=\"content\">{sections}\n            </div>\n\n            <!-- Footer -->\n            <footer class=\"footer\">\n                <p>Last updated: {}</p>\n                <p>© 2026 {}. All rights reserved.</p>\n            </footer>",
        profile.meta.last_updated, profile.person.name
    );

    let seo = format!(
        "<title>{} - {}</title>\n    <meta name=\"description\" content=\"{}\">\n    <meta name=\"keywords\" content=\"{}\">\n    <meta name=\"author\" content=\"{}\">",
        profile.person.name, key.title, key.seo.description, key.seo.keywords, key.seo.author
    );

    template
        .replace("<!-- CONTENT_PLACEHOLDER -->", &content)
        .replace("<!-- SEO_PLACEHOLDER -->", &seo)
        .replace("<!-- NAV_PLACEHOLDER -->", &nav)
}

// ---------------------------------------------------------------------------
// main
// ---------------------------------------------------------------------------

fn main() {
    let filter = std::env::args().nth(1);

    let profile: Profile = serde_yaml::from_str(
        &fs::read_to_string("content/profile.yaml").expect("không đọc được content/profile.yaml (chạy script từ repo root)"),
    )
    .expect("content/profile.yaml không đúng schema");

    let keymap: Keymap = serde_yaml::from_str(
        &fs::read_to_string("content/keymap.yaml").expect("không đọc được content/keymap.yaml"),
    )
    .expect("content/keymap.yaml không đúng schema");

    let template = fs::read_to_string("web/template.html").expect("không đọc được web/template.html");

    let keys_to_build: Vec<&ProfileKey> = keymap
        .profiles
        .iter()
        .filter(|k| filter.as_deref().is_none_or(|f| f == k.id))
        .collect();

    if keys_to_build.is_empty() {
        panic!("Không tìm thấy profile '{}' trong content/keymap.yaml", filter.unwrap());
    }

    for key in &keys_to_build {
        let html = build_page(&profile, key, &template);

        let out_dir = format!("web/profiles/{}", key.id);
        fs::create_dir_all(&out_dir).expect("không tạo được thư mục output");
        fs::write(format!("{out_dir}/index.html"), &html).expect("ghi index.html thất bại");
        fs::copy("web/styles.css", format!("{out_dir}/styles.css")).expect("copy styles.css thất bại");
        println!("✅ web/profiles/{}/index.html", key.id);

        if key.id == keymap.default {
            fs::write("web/index.html", &html).expect("ghi web/index.html thất bại");
            println!("✅ web/index.html (default: {})", key.id);
        }
    }

    let json_dir = Path::new("app/assets/data");
    fs::create_dir_all(json_dir).expect("không tạo được app/assets/data");
    let mut public_profile = profile.clone();
    for p in &mut public_profile.projects {
        p.title = p.display_title().to_string();
        p.alter_title = None;
    }
    let json = serde_json::to_string_pretty(&public_profile).expect("serialize profile.yaml sang JSON thất bại");
    fs::write(json_dir.join("profile.json"), json).expect("ghi app/assets/data/profile.json thất bại");
    println!("✅ app/assets/data/profile.json");
}
