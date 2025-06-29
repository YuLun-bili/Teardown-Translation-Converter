# Teardown Translation Converter

A simple tool to convert crowdin's CSV format localization files to Teardown's `.str` format files

### Usage

* Run application
* Enter file path and name according to displayed prompt
* Check and proceed if correct, or re-enter for correction
* Wait for application to finish executing

> [!NOTE]
> "localization files' folder" refers to **unzipped** folder downloaded from crowdin's "Download as ZIP" exportation method.
> 
> E.g.: Project name "My Project" -> path towards "My Project (translations)" folder, which have several folders named by language code (such as "en", "de", "es-ES") inside after unzipped

> [!IMPORTANT]
> Currently only supports CSV (comma/tab/whitespace)

### Other

* Compiled to executable via [rtc](https://github.com/samyeyo/rtc)
* Icon edited from <a href="https://www.flaticon.com/free-icons/translation" title="translation icons">icon_small - Flaticon</a> and game Teardown's icon
