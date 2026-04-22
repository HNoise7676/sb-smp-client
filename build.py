# /// script
# dependencies = ["rich"]
# ///

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
    start_time = time.perf_counter() # Start the timer
    
    cwd = Path.cwd()
    output_filename = output_name if output_name.endswith(".mrpack") else f"{output_name}.mrpack"
    output_path = cwd / output_filename

    # Define exclusions
    EXCLUDED_NAMES = {".git", ".gitignore", "build.py", "README.md", output_filename}
    
    files_to_pack = []
    total_uncompressed_size = 0

    # Optimized file discovery using pathlib
    for path in cwd.rglob('*'):
        if path.is_file():
            # Skip excluded files and anything inside excluded directories
            if any(part in EXCLUDED_NAMES for part in path.parts) or path.suffix == ".mrpack":
                continue
            
            files_to_pack.append(path)
            total_uncompressed_size += path.stat().st_size

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
                # Modrinth format logic
                if file.name == "modrinth.index.json" and file.parent == cwd:
                    arcname = file.name
                else:
                    arcname = Path("overrides") / file.relative_to(cwd)

                zipf.write(file, arcname)
                progress.update(task, advance=1, description=f"Packing [status.yellow]{file.name[:25]}[/status.yellow]")

    end_time = time.perf_counter()
    duration = end_time - start_time
    
    final_size = output_path.stat().st_size
    ratio = (1 - (final_size / total_uncompressed_size)) * 100 if total_uncompressed_size > 0 else 0

    ascii_header = Text(r"""
 ____  ____   ____  __  __ ____
/ ___|| __ ) / ___||  \/  |  _ \
\___ \|  _ \ \___ \| |\/| | |_) |
 ___) | |_) | ___) | |  | |  __/
|____/|____/ |____/|_|  |_|_|
    """, style="mr.green")

    info_table = Table.grid(padding=(0, 2))
    info_table.add_column(style="fetch.key", justify="right")
    info_table.add_column(style="fetch.val")
    info_table.add_row("PACK", output_filename)
    info_table.add_row("SIZE", get_size_format(final_size))
    info_table.add_row("FILES", str(len(files_to_pack)))
    info_table.add_row("COMP", f"{ratio:.1f}% reduction")
    info_table.add_row("TIME", f"{duration:.2f}s") # Added time display
    info_table.add_row("STATUS", "ready for testing")

    footer = Text("\nThanks for using the StreakBusters SMP client.\nMake sure to report any bugs you find.", style="italic grey62")

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
        console.print(f"[error.red]Failure:[/error.red] {e}")