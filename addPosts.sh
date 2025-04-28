#!/bin/bash

# Script to move Obsidian notes with 'publish' tag to blog posts directory, overwriting existing files and removing publish tag

# Define source and destination directories
OBSIDIAN_VAULT="$HOME/Documents/Vortex/0x00_Zettelkasten"  # Replace with your Obsidian vault path
BLOG_POSTS="$HOME/Projects/blog/content/posts"          # Replace with your blog posts directory

# --- 1. 严格检查环境变量是否存在且有效 ---
if [ -z "$OBSIDIAN_VAULT" ] || [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo "Error: Obsidian vault directory is unset or does not exist at '$OBSIDIAN_VAULT'" >&2
    exit 1
fi

if [ -z "$BLOG_POSTS" ] || [ ! -d "$BLOG_POSTS" ]; then
    echo "Error: Blog posts directory is unset or does not exist at '$BLOG_POSTS'" >&2
    exit 1
fi

# --- 2. 移除初始的 `grep -l "publish"`，直接检查Frontmatter ---
find "$OBSIDIAN_VAULT" -type f -name "*.md" | while read -r file; do
    # --- 3. 严格检查Frontmatter中的publish标签（不依赖行数限制） ---
    if awk '/^---$/ { if (++count == 2) exit; next } count == 1' "$file" | grep -q "publish"; then
        filename=$(basename "$file")
        echo "Processing: $filename"

        # --- 5. 确保临时文件会被清理 ---
        temp_file=$(mktemp) || { echo "Error: Failed to create temp file" >&2; exit 1; }
        trap 'rm -f "$temp_file"' EXIT ERR

        # --- 原始awk脚本（未修改YAML兼容性部分） ---
        awk '
        BEGIN { in_frontmatter=0; in_tags=0 }
        /^---$/ { 
            if (in_frontmatter == 0) { 
                in_frontmatter=1; 
                print; 
                next 
            } else if (in_frontmatter == 1) { 
                in_frontmatter=0; 
                in_tags=0; 
                print; 
                next 
            } 
        }
        in_frontmatter && /^[ \t]*tags:[ \t]*$/ { 
            in_tags=1; 
            print; 
            next 
        }
        in_frontmatter && in_tags && /^[ \t]*-[ \t]*publish[ \t]*$/ { 
            next 
        }
        in_frontmatter && in_tags && /^[ \t]*-[ \t]*[^ \t]/ { 
            print; 
            next 
        }
        in_frontmatter && in_tags && !/^[ \t]*-/ { 
            in_tags=0; 
            print; 
            next 
        }
        { print }
        ' "$file" > "$temp_file"

        # --- 6. 处理文件名中的特殊字符 ---
        echo "Moving '$filename' to '$BLOG_POSTS' (overwrite if exists)"
        mv -f "$temp_file" "$BLOG_POSTS/$filename" || { echo "Error: Failed to move file" >&2; exit 1; }

        echo "Success: Removed 'publish' tag from '$filename'"

    fi
done

# --- 7. 性能优化：使用单个find循环，已内置处理 ---
echo "Completed moving published notes to '$BLOG_POSTS'"