# !/usr/bin/python
# -*- coding=utf-8 -*-

# 1、Two Sum
def twoSum(nums, target):
    """
    :param nums: List[int]
    :param target: int
    :return: List[int]
    """
    resList = []
    length = len(nums)
    for i in range(length-1):
        for j in range(i+1, length):
            if nums[i] + nums[j] == target:
                resList.append(i)
                resList.append(j)
                return resList

# 2、Add Two Numbers
class ListNode(object):
    def __init__(self, x):
        self.val = x
        self.next = None
def addTwoNumbers(l1, l2):
    """
    :param l1: ListNode
    :param l2: ListNode
    :return: ListNode
    """
    isAdd = 0
    firstNode = ListNode((l1.val + l2.val) % 10)
    if l1.val + l2.val >= 10:
        isAdd = 1
    nodeList = []
    nodeList.append(firstNode)
    while l1.next != None or l2.next != None:
        if l1.next != None and l2.next != None :
            l1 = l1.next
            l2 = l2.next
            tempNode = ListNode((l1.val + l2.val + isAdd) % 10)
            nodeList.append(tempNode)
            if l1.val+l2.val+isAdd >= 10:
                isAdd = 1
            else:
                isAdd = 0
        elif l1.next != None:
            l1 = l1.next
            tempNode = ListNode((l1.val + isAdd) % 10)
            nodeList.append(tempNode)
            if l1.val+isAdd >= 10:
                isAdd = 1
            else:
                isAdd = 0
        else:
            l2 = l2.next
            tempNode = ListNode((l2.val + isAdd) % 10)
            nodeList.append(tempNode)
            if l2.val+isAdd >= 10:
                isAdd = 1
            else:
                isAdd = 0
    if isAdd == 1:
        lastNode = ListNode(1)
        nodeList.append(lastNode)
    nodeListRev = list(reversed(nodeList))
    length = len(nodeListRev)
    for i in range(1,length):
        nodeListRev[i].next = nodeListRev[i-1]
    return nodeListRev[-1]

# 3、Longest Substring Without Repeating Characters
def lengthOfLongestSubstring(s):
    """   bdvdafad
    :type s: str
    :rtype: int
    """
    start = 0
    maxLength = 0
    usedStr = {}
    for i in range(len(s)):
        if s[i] in usedStr and start <=  usedStr[s[i]]:
            start = usedStr[s[i]] + 1
        else:
            maxLength = max(maxLength, i-start+1)
        usedStr[s[i]] = i
    return maxLength

# 4、Median of Two Sorted Arrays
# def findMedianSortedArrays(nums1, nums2):
#     """
#     :param nums1: List[int]
#     :param nums2: List[int]
#     :return: int
#     """
#     print("to do code")

def median(A, B):
    m, n = len(A), len(B)
    if m > n:
        A, B, m, n = B, A, n, m
    if n == 0:
        raise ValueError

    imin, imax, half_len = 0, m, (m + n + 1) / 2
    while imin <= imax:
        i = (imin + imax) / 2
        j = half_len - i
        if i < m and B[j-1] > A[i]:
            imin = i + 1
        elif i > 0 and A[i-1] > B[j]:
            imax = i - 1
        else:
            if i == 0:
                max_of_left = B[j-1]
            elif j == 0:
                max_of_left = A[i-1]
            else:
                max_of_left = max(A[i-1], B[j-1])

            if (m+n) % 2 == 1:
                return max_of_left

            if i == m:
                min_of_right = B[j]
            elif j == n:
                min_of_right = A[i]
            else:
                min_of_right = min(A[i], B[j])

            return (max_of_left + min_of_right) / 2.0


a = [1,2,3,4]
b = [2,3,4,5]
print(median(a,b))