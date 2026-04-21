# /// script
# dependencies = ["rich"]
# ///

import os
import zipfile
import argparse
import time
from pathlib import Path
from rich.console import Console, Group
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn
from rich.theme import Theme
from rich.style import Style
from rich.prompt import Prompt
from rich.panel import Panel
from rich.table import Table
from rich.text import Text

# Modrinth-inspired color palette
MR_GREEN = "#1BD96A"
MR_DARK = "#111111"

modrinth_theme = Theme({
    "mr.green": MR_GREEN,
    "mr.dark": MR_DARK,
    "bold.white": "bold #ffffff",
    "status.yellow": "#FFD43B",
    "error.red": "#FF4F4F",
    "fetch.key": f"bold {MR_GREEN}",
    "fetch.val": "#A0A0A0"
})

console = Console(theme=modrinth_theme)

def get_size_format(b, factor=1024, suffix="B"):
    for unit in ["", "K", "M", "G", "T"]:
        if b < factor:
            return f"{b:.2f}{unit}{suffix}"
        b /= factor

def create_mrpack(output_name: str):
    cwd = Path.cwd()
    output_filename = output_name if output_name.endswith(".mrpack") else f"{output_name}.mrpack"
    output_path = cwd / output_filename

    files_to_pack = []
    total_uncompressed_size = 0

    for root, dirs, files in os.walk(cwd):
        for file in files:
            file_path = Path(root) / file
            if file_path.suffix.lower() == '.mrpack':
                continue
            files_to_pack.append(file_path)
            total_uncompressed_size += file_path.stat().st_size

    if not files_to_pack:
        console.print("[error.red]Error:[/error.red] No files found in the current directory.")
        return

    console.print(f"[mr.green]Modrinth Packager[/mr.green] | [bold.white]{output_filename}[/bold.white]\n")

    with Progress(
        SpinnerColumn(spinner_name="dots", style="mr.green"),
        TextColumn("[bold white]{task.description}"),
        BarColumn(bar_width=None, pulse_style=Style(color=MR_GREEN), complete_style="mr.green"),
        TaskProgressColumn(text_format="[mr.green]{task.percentage:>3.0f}%[/mr.green]"),
        console=console,
        transient=True
    ) as progress:

        task = progress.add_task("Compiling...", total=len(files_to_pack))

        with zipfile.ZipFile(output_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for file in files_to_pack:
                if file.name == "index.json" and file.parent == cwd:
                    arcname = file.name
                else:
                    arcname = os.path.join("overrides", file.relative_to(cwd))

                zipf.write(file, arcname)
                time.sleep(0.02)
                progress.update(task, advance=1, description=f"Packing [status.yellow]{file.name[:20]}[/status.yellow]")

        time.sleep(0.5)

    final_size = output_path.stat().st_size
    ratio = (1 - (final_size / total_uncompressed_size)) * 100 if total_uncompressed_size > 0 else 0

    # Fixed: Raw string (r"") to prevent SyntaxWarning
    ascii_header = Text(r"""
   ____  ____    ____  __  __ ____
  / ___|| __ )  / ___||  \/  |  _ \
  \___ \|  _ \  \___ \| |\/| | |_) |
   ___) | |_) |  ___) | |  | |  __/
  |____/|____/  |____/|_|  |_|_|
    """, style="mr.green")

    info_table = Table.grid(padding=(0, 2))
    info_table.add_column(style="fetch.key", justify="right")
    info_table.add_column(style="fetch.val")
    info_table.add_row("PACK", output_filename)
    info_table.add_row("SIZE", get_size_format(final_size))
    info_table.add_row("FILES", str(len(files_to_pack)))
    info_table.add_row("COMP", f"{ratio:.1f}% reduction")
    info_table.add_row("STATUS", "ready for testing")

    footer = Text("\nThanks for using the StreakBusters SMP client.\nMake sure to report any bugs you find.", style="italic grey62")

    # Fixed: Wrapping in Group() to allow Panel to render multiple items
    render_group = Group(ascii_header, info_table, footer)

    console.print(
        Panel(
            render_group,
            border_style="mr.green",
            expand=False,
            padding=(1, 4)
        )
    )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-a", "--auto", action="store_true")
    parser.add_argument("-n", "--name", default="sb-smp-client")
    args = parser.parse_args()

    if args.auto:
        name = args.name
    else:
        name = Prompt.ask("[bold.white]Enter pack name[/]", default=args.name)

    try:
        create_mrpack(name)
    except Exception as e:
        # For debugging, you can use console.print_exception() here
        console.print(f"[error.red]Failure:[/error.red] {e}")
