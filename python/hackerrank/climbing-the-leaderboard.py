def climbingLeaderboard(ranked, player):
    # Remove duplicates from ranked while maintaining order
    unique_ranked = sorted(set(ranked), reverse=True)
    # Create a list to store the results
    result = []
    # Initialize the index to traverse the unique_ranked from the end of the list
    index = len(unique_ranked) - 1

    # Iterate over each of the player's scores
    for score in player:
        # While we have not reached the start of the list and the player's score
        # is greater than or equal to the score on the leaderboard
        while index >= 0 and score >= unique_ranked[index]:
            # Move up the ranked list
            index -= 1
        # Add the player's rank to the results
        # If index is -1, the player is in first place
        # Otherwise, their rank is one more than the index of the last score they surpassed
        result.append(index + 2)  # Rankings start at 1, not 0
    return result


# Testing the function
print(climbingLeaderboard(ranked, player))

if __name__ == '__main__':
    fptr = open(os.environ['OUTPUT_PATH'], 'w')

    ranked_count = int(input().strip())

    ranked = list(map(int, input().rstrip().split()))

    player_count = int(input().strip())

    player = list(map(int, input().rstrip().split()))

    result = climbingLeaderboard(ranked, player)

    fptr.write('\n'.join(map(str, result)))
    fptr.write('\n')

    fptr.close()
