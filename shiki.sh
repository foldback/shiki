# Wikipedia in the shell
# https://www.mediawiki.org/wiki/API:Main_page
# https://www.mediawiki.org/wiki/Extension:TextExtracts
# For `formatversion=1` use `sed 's/"}}}.*//'
# Usage: `wiki unix` or `wiki -l "Ghost in the Shell"`
# Options: -l(ong) and -s(hort)
# Major props to konsolebox

wiki() {
  local data=() encoded_data lang long_mode=false simple_mode=false url

  while [[ $# -gt 0 ]]; do
    case $1 in
    -l|--long)
      long_mode=true
      ;;
    -s|-simple)
      simple_mode=true
      ;;
    -ls|-sl|-s -l|-l -s|--simple-long|--long-simple)
      long_mode=true
      simple_mode=true
      ;;
    -*)
      echo "Invalid option: $1"
      return 1
      ;;
    --)
      data+=("${@:2}")
      break
      ;;
    *)
      data+=("$1")
      ;;
    esac

    shift
  done

  case ${#data[@]} in
  0)
    echo "Data argument needed."
    return 1
    ;;
  1)
    ;;
  *)
    echo "Too many data arguments passed."
    return 1
    ;;
  esac

  encoded_data=$(python -c "import urllib, sys; print urllib.quote(sys.argv[1])" "$data") || return 1
  if [[ $simple_mode == true ]]; then lang="simple"; else lang="en"; fi;
  url="https://${lang}.wikipedia.org/w/api.php?action=query&titles=${encoded_data}&prop=extracts&exlimit=max&explaintext&format=json&formatversion=2&redirects="
  [[ $long_mode == true ]] || url+="&exintro"
  curl -fsSL "$url" | sed 's/^.*"extract":"//; s/"}\]}.*//; s/\\n/\'$'\n''/g' | less
}
