# Wikipedia in the shell
# © Jorrit Visser <git.io/jorvi>
# Major props to konsolebox <git.io/konsolebox>

# Usage: `shiki unix`, `shiki -f "Ghost in the Shell" --language fr`
# Options: `-s/--simple`, `-f/--full` and `$article -l/--language`
# '--simple' and '--language' can't be used together

shiki() {
  local article="" encoded_article lang="" url full_mode=false simple_mode=false

  while [ "${#}" -gt 0 ]; do
    case "${1}" in # Check if first argument is an option
    -f|--full)
      full_mode=true # request full article
    ;;
    -s|--simple)
      simple_mode=true # request simple article
    ;;
    -fs|-sf|--simple-full|--full-simple)
      full_mode=true
      simple_mode=true
    ;;
    -l|--language)
      lang="${2}"
      shift # Use shift to eat argument
    ;;
    --)
      shift
      if [ "${#}" -gt 0 ] && [ -n "${article}" ]; then
        printf "You can't request multiple articles!\n"
        return 1
      fi
      article="${1}"
      break # break out of `case` to prevent 'article' reassignment
    ;;
    -*)
      printf "Invalid option: ${1}!\n"
      return 1
    ;;
    *)
      if [ -n "${article}" ]; then
        printf "You can't request multiple articles!\n"
        return 1
      fi
      article="${1}"
    ;;
    esac

    shift
  done

  # Check if article string is set
  if [ -z "${article}" ]; then
    printf "You must specify an article!\n"
    return 1
  fi

  # URL-encode article string
  encoded_article="$(python -c "import urllib, sys; print urllib.quote(sys.argv[1])" "${article}")" || return 1

  if [ -n "${lang}" ] && [ "${simple_mode}" = true ]; then
    printf "'--simple' and '--language' can't be used together!\n" # 'simple' is considered a language
    return 1
  elif [ "${simple_mode}" = true ]; then
    lang="simple"
  elif [ -z "${lang}" ]; then
    lang="en" # if language is not set, default to English
  fi;

  # https://www.mediawiki.org/wiki/API:Main_page
  # https://www.mediawiki.org/wiki/Extension:TextExtracts
  url="https://${lang}.wikipedia.org/w/api.php?action=query&titles=${encoded_article}&prop=extracts&exlimit=max&explaintext&format=json&formatversion=2&redirects="
  [ "${full_mode}" = true ] || url="${url}&exintro" # Full or short article

  # Remove all markup cruft at article boundaries, with `sed`
  # For `formatversion=1` use `sed 's/"}}}.*//'`
  # Literal newline `sed` hack for POSIX compatibility
  curl -fsSL "${url}" | sed 's/^.*"extract":"//; s/"}\]}.*//; s/\\n/\
/g' | fmt -w "$(tput cols)" | less -m +Gg # Pipe into `less` for cleaner article browsing
}
