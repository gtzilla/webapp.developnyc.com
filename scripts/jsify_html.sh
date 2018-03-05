#!/bin/bash

HTML_DIR="js-templates"
OUT_DIR="js-dist"
OUT_FILE="templates.js"

mkdir -p "$OUT_DIR"
# reset the file
echo -e "/**auto-generated*/\\nvar templates = {};" > ${OUT_DIR}/${OUT_FILE}
# JS `syntax` for an object.
# 	templates.template_name = `<div></div>`;
for fullfile in ${HTML_DIR}/*.html; do
	name=$(basename "$fullfile" .html)
	echo -e "templates.${name}=\`\\n$(cat $fullfile)\\n\`;" >> ${OUT_DIR}/${OUT_FILE}
done