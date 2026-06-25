with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

# Fix the manual release tag creation missing the `prepare-release-tag` output on standard pushes.
# If it's a regular tag push, the tag is github.ref_name.
# However, `prepare-release-tag` is skipped unless it's a workflow_dispatch, so its outputs are empty.
text = text.replace('''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ !failure() && !cancelled() && needs.route.outputs.run_release == 'true' }}
    runs-on: ubuntu-latest
    steps:
      - name: Collect artifacts
        uses: actions/download-artifact@v4
        with:
          name: typst-artifacts
          path: dist-release
      - name: Get tag for release
        id: get_tag
        run: |
          TAG="${{ github.ref_name }}"
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            TAG="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "TAG=$TAG" >> "$GITHUB_ENV"
      - name: Publish GitHub release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ env.TAG }}
          draft: false
          files: dist-release/**
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}''', '''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ always() && needs.route.outputs.run_release == 'true' && needs.typst-build.result == 'success' }}
    runs-on: ubuntu-latest
    steps:
      - name: Collect artifacts
        uses: actions/download-artifact@v4
        with:
          name: typst-artifacts
          path: dist-release
      - name: Get tag for release
        id: get_tag
        run: |
          TAG="${{ github.ref_name }}"
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            TAG="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "TAG=$TAG" >> "$GITHUB_ENV"
      - name: Publish GitHub release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: ${{ env.TAG }}
          draft: false
          files: dist-release/**
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}''')

text = text.replace('''  manual-gh-release:
    name: Manual release creation
    needs: [prepare-release-tag, typst-build]
    if: ${{ github.event_name == 'workflow_dispatch' && startsWith(inputs.mode, 'release-') }}''', '''  manual-gh-release:
    name: Manual release creation
    needs: [prepare-release-tag, typst-build]
    if: ${{ always() && github.event_name == 'workflow_dispatch' && startsWith(inputs.mode, 'release-') && needs.typst-build.result == 'success' }}''')


with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
