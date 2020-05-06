//
//  MutableCollections.swift
//

import Foundation

/**
 A mutable, unordered collection of distinct objects.
 */
public class MutableSet<Element:Hashable&CustomStringConvertible> : Sequence, CustomStringConvertible {
    
    /// The underlying set
    private var delegate = Set<Element>()
    
    /// A string representing the set
    public var description: String {
        return delegate.description
    }
    
    /// Number of items in set
    public var count : Int {
        return delegate.count
    }
    
    /// Sequence method to create an iterator for the MutableSet.
    public func makeIterator() -> Set<Element>.Iterator {
        return delegate.makeIterator()
    }
    
    /**
     Inserts the given element in the set if it is not already present.
     
     **Modifies**: self
     
     **Effects**: adds elem to the set if it is not present
     
     - Parameter elem : Element to insert
     */
    public func insert(_ elem : Element) {
        delegate.insert(elem)
    }
    
    /**
     Returns a Boolean value that indicates whether the given element exists in the set.
     - Parameter elem: An element to look for in the set.
     - Returns: true if member exists in the set; otherwise, false.
     */
    public func contains(_ elem : Element) -> Bool {
        return delegate.contains(elem)
    }
    
    /**
     Removes the given element from the set.
     
     **Modifies**: self
     
     **Effects**: removes elem from the
     
     - Parameter elem : Element to remove
     - Returns: true iff elem was in set
     */
    func remove(_ elem : Element) -> Bool {
        let present = delegate.contains(elem)
        if present {
            delegate.remove(elem)
        }
        return present
    }
}


/**
 A modifiable array of elements.
 */
public class MutableArray<Element:Equatable> : MutableCollection, CustomStringConvertible {
    
    /// The underlying mutable array
    private var delegate = [Element]()
    
    /// A string representing the array
    public var description: String {
        return delegate.description
    }
    
    /// Number of items in array
    public var count : Int {
        return delegate.count
    }
    
    /// Sequence method to create an iterator for the MutableSet.
    public func makeIterator() -> Array<Element>.Iterator {
        return delegate.makeIterator()
    }
    
    /// - Parameter i: A valid index of the collection. i must be less than endIndex.
    /// - Returns the position immediately after the given index.
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    /// The position of the first element in a nonempty array.
    public var startIndex: MutableArray<Element>.Index {
        return 0
    }
    
    /// The array’s “past the end” position—that is, the position one
    /// greater than the last valid subscript argument.
    public var endIndex: MutableArray<Element>.Index {
        return delegate.count
    }
    
    /**
     Accesses the element at the specified position.
     
     **Modifies**: The setter modifies self.
     
     **Effects**: The setter updates the value at index.
     
     - Parameter index: The position of the element to access. index
     must be greater than or equal to startIndex and less than endIndex.
     */
    public subscript(index: Int) -> Element {
        get {
            return delegate[index]
        }
        set(newValue) {
            delegate[index] = newValue
        }
    }
    
    /**
     Adds a new element at the end of the array.
     
     **Modifies**: self
     
     **Effects**: adds elem to the end.
     
     - Parameter elem: The element to append to the array.
     */
    public func append(_ elem: Element) {
        delegate.append(elem)
    }
    
    /**
     Inserts a new element into the collection at the specified position.
     
     **Modifies**: self
     
     **Effects**: inserts elem at the given index.
     
     - Parameter elem: The new element to insert into the collection.
     - Parameter index: The position at which to insert the new element.
     index must be a valid index into the collection.
     */
    public func insert(_ elem: Element, at index: Int) {
        delegate.insert(elem, at: index)
    }
    
    /**
     Removes and returns the element at the specified position.
     
     **Modifies**: self
     
     **Effects**: removes the element at index.
     
     - Parameter index: The position of the element to remove.
     index must be a valid index of the array.
     - Returns: The element at the specified index.
     */
    public func remove(at index: Int) -> Element {
        let elem = delegate.remove(at: index)
        return elem
    }
    
    /**
     Removes and returns last element in the array.
     
     **Modifies**: self
     
     **Effects**: removes the last element in the array, if exists.
     
     - Returns: The element removed, or nil if array was empty.
     */
    public func removeLast() -> Element? {
        let elem = delegate.last
        if elem != nil {
            delegate.removeLast()
        }
        return elem
    }
    
    /**
     Returns a Boolean value that indicates whether the given element exists in the set.
     - Parameter elem: An element to look for in the set.
     - Returns: true if member exists in the set; otherwise, false.
     */
    public func contains(_ elem : Element) -> Bool {
        return delegate.contains { $0 == elem }
    }
    
}

/**
 Mutable associations of keys and values.
 */
public class MutableDictionary<Key : Hashable,Value> : Sequence, CustomStringConvertible {
    
    /// The underlying map
    private var delegate = [Key:Value]()
    
    /// A string representing the set
    public var description: String {
        return delegate.description
    }
    
    /// Number of items in set
    public var count : Int {
        return delegate.count
    }
    
    /// Sequence method to create an iterator for the MutableSet.
    public func makeIterator() ->  Dictionary<Key,Value>.Iterator {
        return delegate.makeIterator()
    }
    
    /// An array containing just the keys of the dictionary.
    public var keys : [Key] {
        return Array(delegate.keys)
    }
    
    /// An array containing just the values of the dictionary.
    public var values : [Value] {
        return Array(delegate.values)
    }
    
    /**
     Accesses the value associated with the given key for reading and writing.
     
     **Modifies**: The setter modifies self.
     
     **Effects**: The setter updates the value for the given key.
     
     - Parameter key: The key of the association we are looking for
     */
    public subscript(_ key : Key) -> Value? {
        get {
            return delegate[key]
        }
        set(newValue) {
            delegate[key] = newValue
        }
    }
    
}

