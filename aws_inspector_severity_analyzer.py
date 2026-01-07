import pandas as pd
import os
from pathlib import Path

# ===== CONFIG =====
FOLDER_PATH = "/home/vasu.nurukurthi@tavant.com/Desktop/security-patching-Q2-2025/GUILD/Q4 2024/Pre"
SEVERITY_COLUMN = "Severity"
# ==================

def process_file(file_path):
    """Process a single CSV file and return severity counts"""
    try:
        df = pd.read_csv(file_path)
        
        if SEVERITY_COLUMN not in df.columns:
            print(f"⚠️  Column '{SEVERITY_COLUMN}' not found in {os.path.basename(file_path)}")
            return None
        
        # Normalize values
        df[SEVERITY_COLUMN] = df[SEVERITY_COLUMN].str.upper().str.strip()
        counts = df[SEVERITY_COLUMN].value_counts()
        
        return counts
    except Exception as e:
        print(f"❌ Error processing {os.path.basename(file_path)}: {e}")
        return None

def main():
    # Get all CSV files in the folder
    csv_files = list(Path(FOLDER_PATH).glob("*.csv"))
    
    if not csv_files:
        print(f"No CSV files found in {FOLDER_PATH}")
        return
    
    print(f"Found {len(csv_files)} CSV file(s)\n")
    print("=" * 80)
    
    total_high = 0
    total_medium = 0
    total_low = 0
    total_critical = 0
    total_untriaged = 0
    
    for csv_file in csv_files:
        print(f"\n📄 File: {csv_file.name}")
        print("-" * 80)
        
        counts = process_file(csv_file)
        
        if counts is not None:
            high = counts.get('HIGH', 0)
            medium = counts.get('MEDIUM', 0)
            low = counts.get('LOW', 0)
            critical = counts.get('CRITICAL', 0)
            untriaged = counts.get('UNTRIAGED', 0)
            
            print(f"CRITICAL  : {critical}")
            print(f"HIGH      : {high}")
            print(f"MEDIUM    : {medium}")
            print(f"LOW       : {low}")
            print(f"UNTRIAGED : {untriaged}")
            print(f"TOTAL     : {counts.sum()}")
            
            total_critical += critical
            total_high += high
            total_medium += medium
            total_low += low
            total_untriaged += untriaged
    
    # Summary across all files
    print("\n" + "=" * 80)
    print("📊 SUMMARY ACROSS ALL FILES")
    print("=" * 80)
    print(f"CRITICAL  : {total_critical}")
    print(f"HIGH      : {total_high}")
    print(f"MEDIUM    : {total_medium}")
    print(f"LOW       : {total_low}")
    print(f"UNTRIAGED : {total_untriaged}")
    print(f"TOTAL     : {total_critical + total_high + total_medium + total_low + total_untriaged}")

if __name__ == "__main__":
    main()
