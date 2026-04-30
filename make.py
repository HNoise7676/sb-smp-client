# /// script
# dependencies = [
#   "rich",
# ]
# ///
# god please don't break
import os
import zipfile
import time
from pathlib import Path
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, TaskProgressColumn
from rich.console import Console

def create_mrpack():
    console = Console()
    output_filename = "sb-smp-client.mrpack"
    current_dir = Path.cwd()
    script_name = Path(__file__).name
    
    files_to_add = []
    for file_path in current_dir.rglob("*"):
        if file_path.is_file():
            if file_path.name != output_filename and file_path.name != script_name:
                if not any(part.startswith('.') for part in file_path.parts):
                    files_to_add.append(file_path)

    if not files_to_add:
        console.print("[yellow]No files found to pack.[/yellow]")
        return

    start_time = time.perf_counter()

    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(bar_width=40),
        TaskProgressColumn(),
        console=console,
    ) as progress:
        
        task = progress.add_task(f"[cyan]Packing {len(files_to_add)} files...", total=len(files_to_add))
        
        with zipfile.ZipFile(output_filename, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for file_path in files_to_add:
                archive_name = str(file_path.relative_to(current_dir))
                
                # Get the file stats
                mtime = os.path.getmtime(file_path)
                date_time = time.localtime(mtime)[:6]
                
                # FIX: If date is before 1980, force it to 1980-01-01
                if date_time[0] < 1980:
                    date_time = (1980, 1, 1, 0, 0, 0)
                
                # Create ZipInfo object to safely handle the timestamp
                zinfo = zipfile.ZipInfo(archive_name, date_time)
                zinfo.compress_type = zipfile.ZIP_DEFLATED
                
                with open(file_path, "rb") as f:
                    zipf.writestr(zinfo, f.read())
                    
                progress.advance(task)

    duration = round(time.perf_counter() - start_time, 3)
    console.print(f"\n[bold green]✔ Success![/bold green] Created [white]{output_filename}[/white]")
    console.print(f"[italic gray]Note: It took {duration} seconds to build the mrpack.[/italic gray]")

if __name__ == "__main__":
    try:
        create_mrpack()
    except KeyboardInterrupt:
        print("\nBuild cancelled by user.")