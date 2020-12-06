 // Definition for a binary tree node.
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};

#include <vector>

using V = std::vector<TreeNode *>;
using S = V::size_type;

void intoSortedVec(V &v, TreeNode *node) {
    if (!node)
        return;
    intoSortedVec(v, node->left);
    v.push_back(node);
    intoSortedVec(v, node->right);
}

TreeNode *intoBinaryTree(TreeNode **ptr, S len) {
    if (len == 0)
        return nullptr;

    S leftlen = len / 2;
    S rightlen = len - leftlen - 1;
    auto mid = ptr + leftlen;

    (*mid)->left = intoBinaryTree(ptr, leftlen);
    (*mid)->right = intoBinaryTree(mid + 1, rightlen);
    return *mid;
}

class Solution {
public:
    TreeNode *balanceBST(TreeNode *root) {
        V v = V();
        intoSortedVec(v, root);
        return intoBinaryTree(&v[0], v.size());
    }
};

#include <cstdio>

int main() {
    puts("Just take my word for it.");
}
