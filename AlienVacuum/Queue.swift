//
//  Queue.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 18/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

public struct Queue<T:AnyObject>
{
    private var items = [T]()
    
    mutating func enqueue(item: T)
    {
        items.append(item)
    }
    
    mutating func dequeue() -> T?
    {
        return items.removeFirst()
    }
    
    func isEmpty() -> Bool
    {
        return items.isEmpty
    }
    
    func contains(item: T) -> Bool
    {
        for i in 0...items.count-1
        {
            if(item === items[i])
            {
                return true
            }
        }
        
        return false
    }
    
    func peek() -> T?
    {
        return items.first
    }
    
}