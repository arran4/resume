with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

# Fix 1: improper use of always() -> !failure() && !cancelled()
text = text.replace('''  typst-build:
    name: Build Typst document
    needs: [route, discover, prepare-release-tag]
    if: ${{ always() && needs.discover.outputs.has_typst == 'true' && (needs.route.outputs.run_build == 'true' || needs.route.outputs.run_release == 'true') }}''', '''  typst-build:
    name: Build Typst document
    needs: [route, discover, prepare-release-tag]
    if: ${{ !failure() && !cancelled() && needs.discover.outputs.has_typst == 'true' && (needs.route.outputs.run_build == 'true' || needs.route.outputs.run_release == 'true') }}''')

text = text.replace('''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ always() && needs.route.outputs.run_release == 'true' && needs.typst-build.result == 'success' }}''', '''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ !failure() && !cancelled() && needs.route.outputs.run_release == 'true' }}''')

# Note: manual-gh-release should NOT depend on publish-release, or rather publish-release should depend on manual-gh-release to avoid race conditions.
text = text.replace('''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag''', '''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
      - manual-gh-release''')

text = text.replace('''  manual-gh-release:
    name: Manual release creation
    needs: [prepare-release-tag, typst-build]
    if: ${{ always() && github.event_name == 'workflow_dispatch' && startsWith(inputs.mode, 'release-') && needs.typst-build.result == 'success' }}''', '''  manual-gh-release:
    name: Manual release creation
    needs: [prepare-release-tag, typst-build]
    if: ${{ !failure() && !cancelled() && github.event_name == 'workflow_dispatch' && startsWith(inputs.mode, 'release-') }}''')


with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
