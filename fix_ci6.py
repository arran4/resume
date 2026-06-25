with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

text = text.replace('''  typst-build:
    name: Build Typst document
    needs: [route, discover, prepare-release-tag]
    if: ${{ !failure() && !cancelled() && needs.discover.outputs.has_typst == 'true' && (needs.route.outputs.run_build == 'true' || needs.route.outputs.run_release == 'true') }}''', '''  typst-build:
    name: Build Typst document
    needs: [route, discover, prepare-release-tag]
    if: ${{ always() && needs.discover.outputs.has_typst == 'true' && (needs.route.outputs.run_build == 'true' || needs.route.outputs.run_release == 'true') }}''')

with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
