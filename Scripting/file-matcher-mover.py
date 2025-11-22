#!/usr/bin/env python3
"""
file_matcher_mover.py

1. Read list of filenames from a .txt file
2. Search in one or more given directories
3. Save found filenames to 'found.txt'
4. Show summary + ask to proceed
5. If yes → move files to destination (skip if exists)
6. At end: ask to overwrite duplicates or skip
7. Final detailed summary
"""

import argparse
import shutil
from pathlib import Path
from typing import List, Set, Dict


def read_filenames(file_list_path: Path) -> List[str]:
    """Read and clean filenames from input file."""
    if not file_list_path.is_file():
        raise FileNotFoundError(f"Input file not found: {file_list_path}")
    
    with file_list_path.open('r', encoding='utf-8') as f:
        return [line.strip() for line in f if line.strip()]


def search_in_directories(filenames: List[str], search_dirs: List[Path]) -> Dict[str, Path]:
    """Search for each filename in given directories. Return dict: filename -> path."""
    found_map = {}
    for filename in filenames:
        for dir_path in search_dirs:
            file_path = dir_path / filename
            if file_path.is_file():
                found_map[filename] = file_path
                break  # Stop after first match
    return found_map


def save_found_to_file(found_map: Dict[str, Path], output_file: Path):
    """Save found filenames (one per line) to 'found.txt'."""
    with output_file.open('w', encoding='utf-8') as f:
        for filename in found_map.keys():
            f.write(filename + '\n')


def print_search_summary(total: int, found: int, not_found: int):
    print("\n" + "="*50)
    print("SEARCH SUMMARY")
    print("="*50)
    print(f"Total filenames in list   : {total}")
    print(f"Found                     : {found}")
    print(f"Not found                 : {not_found}")
    print("="*50)


def print_final_summary(found_files: Set[str], moved: int, skipped: int, overwritten: int, not_found: int):
    print("\n" + "="*60)
    print("FINAL OPERATION SUMMARY")
    print("="*60)
    print(f"Files to process          : {len(found_files)}")
    print(f"Successfully moved        : {moved}")
    print(f"Skipped (already exists)  : {skipped}")
    print(f"Overwritten               : {overwritten}")
    print(f"Not found in search       : {not_found}")
    print("="*60)


def confirm(prompt: str) -> bool:
    """Ask user yes/no and return True/False."""
    while True:
        response = input(f"\n{prompt} (y/n): ").strip().lower()
        if response in ['y', 'yes']:
            return True
        elif response in ['n', 'no']:
            return False
        else:
            print("Please enter 'y' or 'n'.")


def move_files_with_prompt(found_map: Dict[str, Path], dest_dir: Path):
    """Move files, skip if exists, ask to overwrite at end."""
    dest_dir.mkdir(parents=True, exist_ok=True)
    
    to_move = list(found_map.items())
    moved = 0
    skipped = 0
    overwrite_list = []

    print(f"\nMoving {len(to_move)} files to:\n   {dest_dir.resolve()}")

    # First pass: move non-conflicting files
    for filename, src_path in to_move:
        dst_path = dest_dir / filename
        if dst_path.exists():
            overwrite_list.append((filename, src_path, dst_path))
            print(f"SKIP (exists): {filename}")
            skipped += 1
        else:
            try:
                shutil.move(str(src_path), str(dst_path))
                print(f"MOVED: {filename}")
                moved += 1
            except Exception as e:
                print(f"ERROR moving {filename}: {e}")

    # If conflicts, ask user
    if overwrite_list:
        print(f"\n{len(overwrite_list)} file(s) already exist in destination.")
        if confirm("Do you want to overwrite them?"):
            for filename, src_path, dst_path in overwrite_list:
                try:
                    shutil.move(str(src_path), str(dst_path))
                    print(f"OVERWRITTEN: {filename}")
                    moved += 1
                except Exception as e:
                    print(f"ERROR overwriting {filename}: {e}")
        else:
            print("Overwrite skipped.")

    return moved, skipped, len(overwrite_list)


def main():
    parser = argparse.ArgumentParser(
        description="Search and optionally move files listed in a .txt file."
    )
    parser.add_argument("file_list", type=Path, help="Path to .txt file with list of filenames")
    parser.add_argument("search_dirs", nargs='+', type=Path, help="One or more directories to search in")
    parser.add_argument("-d", "--dest", type=Path, help="Destination directory to move files to")

    args = parser.parse_args()

    script_dir = Path(__file__).parent.resolve()
    found_file = script_dir / "found.txt"

    try:
        print("Reading filename list...")
        filenames = read_filenames(args.file_list)
        if not filenames:
            print("No filenames found in the list.")
            return

        print(f"Searching for {len(filenames)} files in {len(args.search_dirs)} director(y|ies)...")

        # Step 2: Search
        found_map = search_in_directories(filenames, args.search_dirs)

        # Step 3: Save found
        save_found_to_file(found_map, found_file)
        print(f"Found filenames saved to: {found_file}")

        # Step 4: Summary + Prompt
        total = len(filenames)
        found = len(found_map)
        not_found = total - found

        print_search_summary(total, found, not_found)

        if found == 0:
            print("No files to move. Exiting.")
            return

        if not args.dest:
            print("No destination directory specified. Exiting.")
            return

        if not confirm("Proceed with moving found files?"):
            print("Operation cancelled by user.")
            return

        # Step 5–6: Move with overwrite prompt
        moved, skipped, conflicts = move_files_with_prompt(found_map, args.dest)

        # Step 7: Final summary
        print_final_summary(
            found_files=set(found_map.keys()),
            moved=moved,
            skipped=skipped,
            overwritten=conflicts - skipped if conflicts > skipped else 0,
            not_found=not_found
        )

        print(f"\nAll operations completed.")
        print(f"Found list: {found_file}")

    except KeyboardInterrupt:
        print("\n\nOperation interrupted by user.")
    except Exception as e:
        print(f"\nUnexpected error: {e}")


if __name__ == "__main__":
    main()
