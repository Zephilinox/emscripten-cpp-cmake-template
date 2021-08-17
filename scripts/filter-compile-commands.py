import json
import sys

def main():
    COMPILE_COMMANDS_INPUT_PATH = sys.argv[1]
    COMPILE_COMMANDS_OUTPUT_PATH = sys.argv[2]
    FILTER_FILES_CONTAINING = sys.argv[3]
    FILTER_FILES_MISSING = sys.argv[4]

    print(f"\nLoading from '{COMPILE_COMMANDS_INPUT_PATH}'")
    print(f"\nFiltering files that contain '{FILTER_FILES_CONTAINING}'")
    print(f"\nFiltering files that do not contain '{FILTER_FILES_MISSING}'")
    with open(COMPILE_COMMANDS_INPUT_PATH, "r") as read_file:
        data_to_filter = json.load(read_file)

    data_to_keep = []
    for section in data_to_filter:
        should_filter = False
        for key, value in section.items():
            if (key == "file" or key == "directory"):
                should_filter_contains = FILTER_FILES_CONTAINING in value
                should_filter_missing = FILTER_FILES_MISSING not in value
                if should_filter_contains:
                    print(f"Filtering '{value}' because it contains '{FILTER_FILES_CONTAINING}'")
                if should_filter_missing:
                    print(f"Filtering '{value}' because it does not contain '{FILTER_FILES_MISSING}'")
                should_filter = should_filter_contains or should_filter_missing
        if not should_filter:
            data_to_keep.append(section)

    print(f"Saving to '{COMPILE_COMMANDS_OUTPUT_PATH}'\n")
    with open(COMPILE_COMMANDS_OUTPUT_PATH, "w") as write_file:
        json.dump(data_to_keep, write_file, indent=4)

if __name__ == '__main__':
    main()
