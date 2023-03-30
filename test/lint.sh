find . -path "./vendor" -prune -o -name "*.rb" | xargs bundle exec rubocop
