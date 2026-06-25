import re

with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

# Make sure we actually fix the publish-draft since my first replace script missed the Get tag for release block
text = re.sub(r'  publish-draft:.*?draft=false\)"\n', r'''  publish:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ needs.route.outputs.run_release == 'true' }}
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
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
''', text, flags=re.DOTALL)

with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
