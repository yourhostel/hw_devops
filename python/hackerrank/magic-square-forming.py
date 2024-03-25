def forming_magic_square(s):
    all_magic_squares = [
        [[8, 1, 6], [3, 5, 7], [4, 9, 2]],
        [[6, 1, 8], [7, 5, 3], [2, 9, 4]],
        [[4, 9, 2], [3, 5, 7], [8, 1, 6]],
        [[2, 9, 4], [7, 5, 3], [6, 1, 8]],
        [[8, 3, 4], [1, 5, 9], [6, 7, 2]],
        [[4, 3, 8], [9, 5, 1], [2, 7, 6]],
        [[6, 7, 2], [1, 5, 9], [8, 3, 4]],
        [[2, 7, 6], [9, 5, 1], [4, 3, 8]],
    ]

    def calc_cost(m1, m2):
        cost = 0
        for i in range(3):
            for j in range(3):
                cost += abs(m1[i][j] - m2[i][j])
        return cost

    min_cost = float('inf')
    for magic_square in all_magic_squares:
        cost = calc_cost(s, magic_square)
        if cost < min_cost:
            min_cost = cost

    return min_cost


if __name__ == '__main__':
    s = []

    for _ in range(3):
        s.append(list(map(int, input().rstrip().split())))

    print(forming_magic_square(s))
