set -eu
set -o pipefail

! grep -r -E "\.to_\w +\|\|" `find . -name "*.rb"` # ex. hoge.to_i || 1
