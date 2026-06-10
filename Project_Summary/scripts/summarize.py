import argparse
import tomllib
from datetime import datetime
from pathlib import Path

from dotenv import load_dotenv
import anthropic

BASE_DIR = Path(__file__).parent.parent


def load_config() -> dict:
    with open(BASE_DIR / "config" / "settings.toml", "rb") as f:
        return tomllib.load(f)


def load_prompt(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip()


def extract_text(input_path: Path) -> str:
    if input_path.suffix.lower() == ".pdf":
        import pdfplumber
        pages = []
        with pdfplumber.open(input_path) as pdf:
            for page in pdf.pages:
                text = page.extract_text()
                if text:
                    pages.append(text)
        return "\n\n".join(pages)
    return input_path.read_text(encoding="utf-8")


def compose_system_prompt() -> str:
    system = load_prompt(BASE_DIR / "prompts" / "system" / "rol_analista.md")
    shared = load_prompt(BASE_DIR / "prompts" / "shared" / "instrucciones_idioma.md")
    return f"{system}\n\n{shared}"


def compose_user_prompt(tipo: str, content: str) -> str:
    task_path = BASE_DIR / "prompts" / "tasks" / f"{tipo}.md"
    if not task_path.exists():
        raise FileNotFoundError(f"No existe el tipo '{tipo}' en prompts/tasks/")

    task = load_prompt(task_path)
    template_file = "formato_latex.md" if "latex" in tipo else "formato_markdown.md"
    template = load_prompt(BASE_DIR / "templates" / template_file)

    return f"{task}\n\n{template}\n\n---\n\nDOCUMENTO:\n{content}"


def clean_output(text: str, tipo: str) -> str:
    text = text.strip()
    if "latex" in tipo:
        for fence in ("```latex", "```tex", "```"):
            if text.startswith(fence):
                text = text[len(fence):]
                break
        if text.endswith("```"):
            text = text[:-3]
    return text.strip()


def save_output(text: str, tipo: str, input_stem: str) -> Path:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    ext = ".tex" if "latex" in tipo else ".md"
    output_dir = BASE_DIR / "outputs"
    output_dir.mkdir(exist_ok=True)
    output_path = output_dir / f"{timestamp}_{input_stem}_{tipo}{ext}"
    output_path.write_text(text, encoding="utf-8")
    return output_path


def summarize(input_file: str, tipo: str) -> None:
    load_dotenv(BASE_DIR / "config" / ".env")
    config = load_config()

    input_path = Path(input_file)
    if not input_path.exists():
        raise FileNotFoundError(f"Archivo no encontrado: {input_file}")

    content = extract_text(input_path)

    tipo_config = config.get("tipos", {}).get(tipo, {})
    max_tokens = tipo_config.get("max_tokens", config["model"]["max_tokens"])

    client = anthropic.Anthropic()
    message = client.messages.create(
        model=config["model"]["name"],
        max_tokens=max_tokens,
        system=compose_system_prompt(),
        messages=[{"role": "user", "content": compose_user_prompt(tipo, content)}],
    )

    result = clean_output(message.content[0].text, tipo)
    output_path = save_output(result, tipo, input_path.stem)

    print(f"Resumen guardado en: {output_path}\n")
    print("=" * 60)
    print(result)


def main() -> None:
    parser = argparse.ArgumentParser(description="Generador automático de resúmenes con Claude")
    parser.add_argument("--input", required=True, help="Ruta al archivo (.txt o .pdf)")
    parser.add_argument(
        "--tipo",
        default="resumen_ejecutivo",
        help="Tipo de resumen (nombre del archivo en prompts/tasks/ sin .md)",
    )
    args = parser.parse_args()
    summarize(args.input, args.tipo)


if __name__ == "__main__":
    main()
