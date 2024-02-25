from _typeshed import Incomplete
from typing import Callable, List, Literal, Tuple

OPERATORS: Incomplete

def get_insertion_index(i: int, comparison: Callable, value: int, arr: List[int]) -> int: ...
def refresh_shortcut_subset(interval: int, arr: List[int], subset: List[int], output_len: int, len_rounded: int) -> List[int]: ...
def get_shortcut_index(compare_idx: int, interval: int, comparison: Callable, arr: List[int], refresh_limit: int, subset: List[int], current_value: int, output_len: int) -> Tuple[int, int, List[int]]: ...
def insertion_sort(input_array: List[int], sort_order: Literal['asc', 'desc'] = 'asc', only_distinct: bool = False, use_shortcuts: bool = False, shortcut_interval: int = 10) -> List[int]: ...
