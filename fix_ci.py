import re

with open('.github/workflows/ci.yml', 'r') as f:
    text = f.read()

# Fix 1: Typst-build tag fetching for draft release needs to use prepare-release-tag
text = text.replace('''
      - name: Get Git reference
        id: tag
        run: |
          REF=${GITHUB_REF#refs/*/}
          REF=${REF//\//-}
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            REF="draft-release"
          fi
          echo "REF=$REF" >> $GITHUB_ENV''', '''
      - name: Get Git reference
        id: tag
        run: |
          REF=${GITHUB_REF#refs/*/}
          REF=${REF//\//-}
          if [[ "${{ github.event_name }}" == "workflow_dispatch" && "${{ inputs.mode }}" == release-* ]]; then
            REF="${{ needs.prepare-release-tag.outputs.release_tag }}"
          fi
          echo "REF=$REF" >> $GITHUB_ENV''')

# Fix 2: Typst-build needs prepare-release-tag if run from manual dispatch
text = text.replace('''  typst-build:
    name: Build Typst document
    needs: [route, discover]''', '''  typst-build:
    name: Build Typst document
    needs: [route, discover, prepare-release-tag]''')

# Fix 3: Publish-draft needs to specify tag_name so it maps to the created tag and promote needs to patch it
text = text.replace('''  publish-draft:
    name: Publish draft release assets
    needs:
      - typst-build
      - route
    if: ${{ needs.route.outputs.run_release == 'true' }}
    runs-on: ubuntu-latest
    steps:
      - name: Collect artifacts
        uses: actions/download-artifact@v4
        with:
          name: typst-artifacts
          path: dist-release
      - name: Publish draft GitHub release
        uses: softprops/action-gh-release@v2
        with:
          draft: true
          files: dist-release/**
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  promote-release:
    name: Promote draft to published
    needs: [publish-draft]
    if: ${{ github.event_name == 'release' || (github.event_name == 'workflow_dispatch' && startsWith(inputs.mode, 'release-')) }}
    runs-on: ubuntu-latest
    steps:
      - name: Release promoted via upstream process
        run: echo "Promotion step placeholder (gh api patch release draft=false)"''', '''  publish-draft:
    name: Publish draft release assets
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
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}''')

with open('.github/workflows/ci.yml', 'w') as f:
    f.write(text)
