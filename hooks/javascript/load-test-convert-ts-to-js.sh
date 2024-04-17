# This should be used by load-test only,

currentBranch=$(git rev-parse --abbrev-ref HEAD)

if git diff-tree --no-commit-id --name-only -r HEAD..origin/$currentBranch | grep -q 'load-test/'; then
    cd load-test
    npm install
    npm run build
fi
