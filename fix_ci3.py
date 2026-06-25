import re

with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

# Fix the manual release tag creation missing the `prepare-release-tag` output on standard pushes.
# If it's a regular tag push, the tag is github.ref_name.
# However, `prepare-release-tag` is skipped unless it's a workflow_dispatch, so its outputs are empty.
text = text.replace('''      - name: Get tag for release
        id: get_tag
        run: |
          TAG="${{ github.ref_name }}"
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            TAG="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "TAG=$TAG" >> "$GITHUB_ENV"''', '''      - name: Get tag for release
        id: get_tag
        run: |
          TAG="${{ github.ref_name }}"
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            TAG="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "TAG=$TAG" >> "$GITHUB_ENV"''')

# Fix in typst-build as well:
text = text.replace('''      - name: Get Git reference
        id: tag
        run: |
          REF=${GITHUB_REF#refs/*/}
          REF=${REF//\//-}
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            REF="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "REF=$REF" >> $GITHUB_ENV''', '''      - name: Get Git reference
        id: tag
        run: |
          REF=${GITHUB_REF#refs/*/}
          REF=${REF//\//-}
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            REF="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "REF=$REF" >> $GITHUB_ENV''')

# Wait, `publish-draft` used to have `needs: [typst-build, route, prepare-release-tag]`.
# But `prepare-release-tag` has `if: ${{ github.event_name == 'workflow_dispatch' ... }}`.
# This means `publish-draft` will be skipped on regular pushes because `prepare-release-tag` is skipped.
# To fix this, `needs.prepare-release-tag` shouldn't block execution if it was skipped. We use `always()` or `!failure() && !cancelled()`.
text = text.replace('''  publish-draft:
    name: Publish draft release assets
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ needs.route.outputs.run_release == 'true' }}''', '''  publish-release:
    name: Publish release
    needs:
      - typst-build
      - route
      - prepare-release-tag
    if: ${{ !failure() && !cancelled() && needs.route.outputs.run_release == 'true' }}''')

with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
