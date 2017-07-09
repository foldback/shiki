# Wikipedia in the shell
# https://www.mediawiki.org/wiki/API:Main_page
# For `formatversion=1` use `sed 's/"}}}.*//'
# Usage: `wiki unix` or `wiki -l "Ghost in the Shell"`
# Options: -l(ong) and -s(hort)

wiki() {
  local Encodeddata=$(python -c "import urllib, sys; print urllib.quote(sys.argv[1])" "${2:-$1}")
  case ${1} in -l|-long) # Full article
    curl -fsSL "https://en.wikipedia.org/w/api.php?action=query&titles=${Encodeddata}&prop=extracts&exlimit=max&explaintext&format=json&formatversion=2&redirects=" | \
    sed 's/^.*"extract":"//' | sed 's/"}\]}.*//' | sed 's/\\n/\
    /g' | less;; # Ugly `sed` hack because `sed 's/\\n/\n/g'` doesn't work on macOS/BSD
  -s|-simple) # Article intro, simplified
    curl -fsSL "https://simple.wikipedia.org/w/api.php?action=query&titles=${Encodeddata}&prop=extracts&exlimit=max&exintro&explaintext&format=json&formatversion=2&redirects=" | \
    sed 's/^.*"extract":"//' | sed 's/"}\]}.*//' | sed 's/\\n/\
    /g' | less;;
  -ls|-sl|-s -l|-l -s|--simple-long|--long-simple) # Full article, simplified
    curl -fsSL "https://simple.wikipedia.org/w/api.php?action=query&titles=${Encodeddata}&prop=extracts&exlimit=max&exintro&explaintext&format=json&formatversion=2&redirects=" | \
    sed 's/^.*"extract":"//' | sed 's/"}\]}.*//' | sed 's/\\n/\
    /g' | less;;
  *) # Article intro
    curl -fsSL "https://en.wikipedia.org/w/api.php?action=query&titles=${Encodeddata}&prop=extracts&exlimit=max&exintro&explaintext&format=json&formatversion=2&redirects=" \
    | sed 's/^.*"extract":"//' | sed 's/"}\]}.*//' | sed 's/\\n/\
    /g' | less;;
  esac
}
