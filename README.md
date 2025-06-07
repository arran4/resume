# Arran Ubels Resume


This is my attempt at a public resume / cv. An unabridged version, abridged versions might be discoverable in snapshots. If you have any suggestions, issues, and the like please raise an issue or a PR. Why else would I do this in git. 

You can download the latest compiled version (in PDF form) from:

https://github.com/arran4/resume/releases

Or build it yourself, you will need to install `typst` on your platform. Details on how to do that can be found here: 

## Installing Typst

1. Visit <https://typst.app/docs/install/> and follow the steps for your operating system.
   - **macOS**: `brew install typst`
   - **Linux**: use your distribution's package manager if available:
     `apt install typst` (Debian/Ubuntu), `dnf install typst` (Fedora),
     `pacman -S typst` (Arch). If no package exists, run the official
     install script:

     ```bash
     curl --proto '=https' --tlsv1.2 -sSf https://typst.app/install.sh | sh
     ```
   - **Windows**: `winget install Typst.Typst` (via the Windows Package
     Manager) or download the release from GitHub.
2. Ensure the `typst` command is available in your `PATH`.

## Building the resume

Run the following commands from the repository root to generate the PDF and PNG outputs:

```bash
# Generate PDF
TYPST_FONT_PATHS=./fonts typst compile resume.typ resume.pdf

# Generate PNG for each page
TYPST_FONT_PATHS=./fonts typst compile -f png resume.typ resume-page-{n}.png
```

This will create `resume.pdf` along with page images in the current directory.

Feel free to fork and use for your own resume, however this is based off [Modern CV](https://typst.app/universe/package/modern-cv/) so you are best to start there, however feel free to copy the github actions code for compiling on tagging:

https://github.com/arran4/resume/blob/main/.github/workflows/typst.yaml

For suggestions / updates etc, please create a fork and then from there create a PR. 
