# /// script
# dependencies = [
#   "questionary==2.0.1",
#   "rich==13.7.0",
# ]
# ///

import os
import json
import zipfile
import subprocess
from pathlib import Path
from rich.console import Console
from rich.panel import Panel
from rich.table import Table
from rich.progress import Progress, SpinnerColumn, BarColumn, TextColumn
import questionary

console = Console()

# Modrinth Brand Colors
MODRINTH_GREEN = "#1bd96a"
ERROR_RED = "#ff5555"

def get_git_changelog():
    """Attempts to get the last 5 git commit messages for the changelog."""
    try:
        cmd = ["git", "log", "-5", "--pretty=format:- %s"]
        changelog = subprocess.check_output(cmd).decode("utf-8")
        return changelog if changelog else "- Initial release"
    except:
        return "- Manual update (Git not found)"

def create_mrpack(options):
    success = True
    errors = []
    pack_name = "sb-smp.mrpack"
    
    # Custom Progress Bar (Modrinth Green)
    with Progress(
        SpinnerColumn(spinner_name="monkey"), # A little fun spinner
        TextColumn("[progress.description]{task.description}"),
        BarColumn(bar_width=40, complete_style=MODRINTH_GREEN, finished_style=MODRINTH_GREEN),
        TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
    ) as progress:
        
        task = progress.add_task("[white]Building pack...", total=100)

        try:
            with zipfile.ZipFile(pack_name, 'w', zipfile.ZIP_DEFLATED) as zipf:
                # Step 1: Metadata
                progress.update(task, advance=20, description="Generating index.json")
                index_data = {
                    "formatVersion": 1,
                    "game": "minecraft",
                    "versionId": "1.0.0",
                    "name": "SB-SMP",
                    "dependencies": {"minecraft": "1.20.1", "fabric-loader": "0.14.22"},
                    "files": []
                }
                zipf.writestr("modrinth.index.json", json.dumps(index_data, indent=4))

                # Step 2: Changelog
                if "Generate Changelog" in options:
                    progress.update(task, advance=20, description="Generating Changelog")
                    changelog_content = get_git_changelog()
                    zipf.writestr("changelog.md", f"# Changelog\n\n{changelog_content}")

                # Step 3: Overrides
                progress.update(task, advance=20, description="Packing overrides")
                path_to_overrides = Path("./overrides")
                if path_to_overrides.exists():
                    files = list(path_to_overrides.rglob('*'))
                    if files:
                        increment = 40 / len(files)
                        for file in files:
                            if file.is_file():
                                zipf.write(file, arcname=f"overrides/{file.relative_to(path_to_overrides)}")
                            progress.update(task, advance=increment)
                else:
                    errors.append("No 'overrides' folder found. Created an empty base pack.")
                    progress.update(task, advance=40)

        except Exception as e:
            success = False
            errors.append(str(e))

    return success, errors

def main():
    console.print(Panel("[bold]SB-SMP PACK BUILDER[/bold]", style=MODRINTH_GREEN, expand=False))

    options = questionary.checkbox(
        "Build Settings:",
        choices=[
            questionary.Choice("Include Configs", checked=True),
            questionary.Choice("Include Scripts", checked=True),
            questionary.Choice("Generate Changelog", checked=True),
        ],
        style=questionary.Style([
            ('selected', f'fg:{MODRINTH_GREEN} bold'),
            ('pointer', f'fg:{MODRINTH_GREEN} bold'),
            ('highlighted', f'fg:{MODRINTH_GREEN}'),
            ('answer', f'fg:{MODRINTH_GREEN}'),
        ])
    ).ask()

    if options is None:
        return

    success, errors = create_mrpack(options)

    # Debug Summary
    console.print("\n[bold]Post-Build Debug Information:[/bold]")
    table = Table(show_header=True, header_style=f"bold {MODRINTH_GREEN}")
    table.add_column("Module")
    table.add_column("Status")
    
    table.add_row("Output Filename", "sb-smp.mrpack")
    table.add_row("Structure", "[green]OK[/green]" if success else "[red]FAILED[/red]")
    
    console.print(table)

    if errors:
        console.print(Panel("\n".join(errors), title="Debug Logs", border_style=ERROR_RED))
    elif success:
        console.print(f"\n[bold {MODRINTH_GREEN}]BUILD COMPLETE![/bold {MODRINTH_GREEN}]")

if __name__ == "__main__":
    main()
