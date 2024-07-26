#!/usr/bin/env bash
if ! git diff --exit-code > /dev/null; then
	echo "❌ DON'T FORGET TO GIT PUSH (git diff) ⚠️"
	exit 0
fi

if git status -sb | grep '\[ahead ' > /dev/null; then
	echo "❌ DON'T FORGET TO GIT PUSH (git status) ⚠️"
	exit 0
fi
