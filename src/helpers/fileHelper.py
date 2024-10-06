import os
import shutil


def deleteAllFiles(directory):
    if os.path.exists(directory):
        for filename in os.listdir(directory):
            file_path = os.path.join(directory, filename)
            try:
                if os.path.isfile(file_path) or os.path.islink(file_path):
                    os.unlink(file_path)
                    print(f"Deleted file: {file_path}")
                elif os.path.isdir(file_path):
                    shutil.rmtree(file_path)
                    print(f"Deleted directory: {file_path}")
            except Exception as e:
                print(f"Failed to delete {file_path}. Reason: {e}")
    else:
        print(f"Directory '{directory}' does not exist.")


def createLargeFile(directory):
    file_name = 'large_file.txt'
    file_path = os.path.join(directory, file_name)

    deleteAllFiles(directory)

    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"Directory '{directory}' created.")

    target_size = 2 * 1024 * 1024 * 1024

    content = 'This is a sample line of text.\n' * 1024

    with open(file_path, 'w') as file:
        total_written = 0

        while total_written < target_size:
            file.write(content)
            total_written += len(content)

    final_size = os.path.getsize(file_path)
    print(f"File '{file_name}' created in '{directory}' with size: {final_size / (1024 * 1024 * 1024):.2f} GB")