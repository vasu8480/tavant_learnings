def min_window(s: str, t: str) -> str:
    from collections import Counter
    
    if not s or not t:
        return ""
    
    target = Counter(t)
    required = len(target)
    formed = 0
    
    window_counts = {}
    l = 0
    min_len = float("inf")
    min_window = ""
    
    for r in range(len(s)):
        char = s[r]
        window_counts[char] = window_counts.get(char, 0) + 1
        
        if char in target and window_counts[char] == target[char]:
            formed += 1
        
        while l <= r and formed == required:
            if (r - l + 1) < min_len:
                min_len = r - l + 1
                min_window = s[l:r+1]
            
            left_char = s[l]
            window_counts[left_char] -= 1
            if left_char in target and window_counts[left_char] < target[left_char]:
                formed -= 1
            l += 1
    
    return min_window