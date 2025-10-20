#!/usr/bin/env python3
"""
Remove duplicate entries from a BibTeX file.
Usage: python remove_bib_duplicates.py references.bib
"""

import re
import sys
from collections import OrderedDict

def parse_bibtex(content):
    """Parse BibTeX file and extract entries with their keys."""
    # Pattern to match @article{key, ... } or @inproceedings{key, ... } etc.
    pattern = r'(@\w+\{([^,\s]+),.*?(?=\n@|\Z))'
    entries = re.findall(pattern, content, re.DOTALL)
    return entries

def remove_duplicates(input_file, output_file=None):
    """Remove duplicate BibTeX entries, keeping the first occurrence."""
    
    if output_file is None:
        output_file = input_file.replace('.bib', '_cleaned.bib')
    
    # Read the file
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract header comments (everything before first @)
    header_match = re.match(r'(.*?)(?=@)', content, re.DOTALL)
    header = header_match.group(1) if header_match else ''
    
    # Parse entries
    entries = parse_bibtex(content)
    
    # Use OrderedDict to keep first occurrence and track duplicates
    seen_keys = OrderedDict()
    duplicates = []
    
    for full_entry, key in entries:
        if key in seen_keys:
            duplicates.append(key)
            print(f"  Removing duplicate: {key}")
        else:
            seen_keys[key] = full_entry
    
    # Reconstruct the file
    cleaned_content = header
    for key, entry in seen_keys.items():
        cleaned_content += entry + '\n\n'
    
    # Write the cleaned file
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(cleaned_content)
    
    # Print summary
    print(f"\n{'='*60}")
    print(f"Original entries: {len(entries)}")
    print(f"Unique entries: {len(seen_keys)}")
    print(f"Duplicates removed: {len(duplicates)}")
    print(f"\nDuplicate keys removed:")
    for dup in duplicates:
        print(f"  - {dup}")
    print(f"\nCleaned file saved to: {output_file}")
    print(f"{'='*60}")
    
    # Create backup
    import shutil
    backup_file = input_file + '.backup'
    shutil.copy(input_file, backup_file)
    print(f"\nBackup created: {backup_file}")
    
    return len(duplicates)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python remove_bib_duplicates.py <bibtex_file>")
        print("Example: python remove_bib_duplicates.py references.bib")
        sys.exit(1)
    
    input_file = sys.argv[1]
    
    try:
        num_duplicates = remove_duplicates(input_file)
        
        if num_duplicates > 0:
            print("\n✓ Duplicates removed successfully!")
            print(f"  Review the cleaned file, then replace the original if satisfied.")
        else:
            print("\n✓ No duplicates found!")
            
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found!")
        sys.exit(1)
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)