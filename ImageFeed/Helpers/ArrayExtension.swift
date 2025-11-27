extension Array {
    func withReplaced(item: Element, at index: Int) -> [Element] {
        guard index >= 0 && index < count else {
            return self
        }
        var mutableArray = self
        mutableArray[index] = item
        return mutableArray
    }
}
