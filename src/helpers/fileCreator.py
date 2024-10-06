import os

target_size = 10 * 1024 * 1024 * 1024
file_name = 'large_file.txt'
content = 'This is a sample line of text.\n' * 1024

with open(file_name, 'w') as file:
    total_written = 0
    
    while total_written < target_size:
        file.write(content)
        
        total_written += len(content)

final_size = os.path.getsize(file_name)
print(f"File '{file_name}' created with size: {final_size / (1024 * 1024 * 1024):.2f} GB")
