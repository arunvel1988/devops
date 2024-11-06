#!/bin/bash

# Variables for branch names
DEV_BRANCH="dev"
STAGE_BRANCH="stage"
PROD_BRANCH="prod"

# Check the current branch
current_branch=$(git branch --show-current)

echo "Current branch: $current_branch"

# Step 1: Merge from dev to stage
merge_dev_to_stage() {
    echo "Merging $DEV_BRANCH into $STAGE_BRANCH..."

    # Checkout to stage branch
    git checkout $STAGE_BRANCH || { echo "Failed to checkout to $STAGE_BRANCH. Exiting..."; exit 1; }

    # Pull the latest changes from stage
    git pull origin $STAGE_BRANCH || { echo "Failed to pull from $STAGE_BRANCH. Exiting..."; exit 1; }

    # Merge dev branch into stage
    git merge $DEV_BRANCH || { echo "Merge failed. Resolve conflicts and try again."; exit 1; }

    # Push the merged stage branch
    git push origin $STAGE_BRANCH || { echo "Failed to push to $STAGE_BRANCH. Exiting..."; exit 1; }

    echo "$DEV_BRANCH successfully merged into $STAGE_BRANCH."
}

# Step 2: Merge from stage to prod
merge_stage_to_prod() {
    echo "Merging $STAGE_BRANCH into $PROD_BRANCH..."

    # Checkout to prod branch
    git checkout $PROD_BRANCH || { echo "Failed to checkout to $PROD_BRANCH. Exiting..."; exit 1; }

    # Pull the latest changes from prod
    git pull origin $PROD_BRANCH || { echo "Failed to pull from $PROD_BRANCH. Exiting..."; exit 1; }

    # Merge stage branch into prod
    git merge $STAGE_BRANCH || { echo "Merge failed. Resolve conflicts and try again."; exit 1; }

    # Push the merged prod branch
    git push origin $PROD_BRANCH || { echo "Failed to push to $PROD_BRANCH. Exiting..."; exit 1; }

    echo "$STAGE_BRANCH successfully merged into $PROD_BRANCH."
}

# Step 3: Merge from dev to prod (if required)
merge_dev_to_prod() {
    echo "Merging $DEV_BRANCH directly into $PROD_BRANCH (if required)..."

    # Checkout to prod branch
    git checkout $PROD_BRANCH || { echo "Failed to checkout to $PROD_BRANCH. Exiting..."; exit 1; }

    # Pull the latest changes from prod
    git pull origin $PROD_BRANCH || { echo "Failed to pull from $PROD_BRANCH. Exiting..."; exit 1; }

    # Merge dev branch into prod
    git merge $DEV_BRANCH || { echo "Merge failed. Resolve conflicts and try again."; exit 1; }

    # Push the merged prod branch
    git push origin $PROD_BRANCH || { echo "Failed to push to $PROD_BRANCH. Exiting..."; exit 1; }

    echo "$DEV_BRANCH successfully merged into $PROD_BRANCH."
}

# Step 4: Cleanup feature branches (optional)
cleanup_feature_branch() {
    echo "Cleaning up feature branches..."

    # Check if feature branch exists and delete locally and remotely
    git branch --list feature-* | while read feature_branch; do
        git branch -d "$feature_branch"
        git push origin --delete "$feature_branch"
        echo "Deleted branch: $feature_branch"
    done
}

# Main workflow
if [ "$current_branch" == "$DEV_BRANCH" ]; then
    echo "You are on the $DEV_BRANCH branch."
    # Merge dev to stage and then stage to prod
    merge_dev_to_stage
    merge_stage_to_prod
elif [ "$current_branch" == "$STAGE_BRANCH" ]; then
    echo "You are on the $STAGE_BRANCH branch."
    # Merge stage to prod
    merge_stage_to_prod
elif [ "$current_branch" == "$PROD_BRANCH" ]; then
    echo "You are on the $PROD_BRANCH branch."
    # Optionally merge dev to prod directly if required
    merge_dev_to_prod
else
    echo "You are not on a branch that is part of the release flow ($DEV_BRANCH, $STAGE_BRANCH, $PROD_BRANCH)."
    exit 1
fi

# Optional Cleanup: Remove feature branches after merge
cleanup_feature_branch

echo "Git flow completed successfully."
