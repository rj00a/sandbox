
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def balanceBST(self, root: TreeNode) -> TreeNode:
        sortedList = []

        def mkSortedList(node):
            if node == None:
                return
            mkSortedList(node.left)
            sortedList.append(node.val)
            mkSortedList(node.right)
        mkSortedList(root)

        def mkTree(segment):
            if len(segment) == 0:
                return None
            mid = len(segment) // 2
            left = mkTree(segment[:mid])
            right = mkTree(segment[mid + 1:])
            return TreeNode(segment[mid], left, right)
        return mkTree(sortedList)

def printTreeNode(node):

    def rec(node, indent):
        if node == None:
            return None
        indent2 = indent + '    '
        res = indent + f"value: {node.val}\n"
        if left := rec(node.left, indent2):
            res += indent + f"left:\n"
            res += left
        if right := rec(node.right, indent2):
            res += indent + f"right:\n"
            res += right
        return res

    print(rec(node, ''))

def shittyTreeFromList(l):
    if len(l) == 0:
        return None
    return TreeNode(l[0], None, shittyTreeFromList(l[1:]))

root = shittyTreeFromList([1, 2, 3, 4, 5, 6, 7, 8])

printTreeNode(Solution().balanceBST(root))