//
//  PathFinder.swift
//  AlienVacuum
//
//  Created by João Vitor dos Santos Schimmelpfeng on 18/05/16.
//  Copyright © 2016 Guilherme. All rights reserved.
//

import Foundation
import Darwin

public class PathFinder
{
    public func findPath(fromX: Int, fromY: Int, toX: Int, toY: Int, map:Map) -> Queue<Path_Node>
    {
        var openList = Queue<Path_Node>()
        var finalList = Queue<Path_Node>()
        
        //receber matriz composta de 0 e -1
        var binaryMat = convertMatrixToBinary(map.matrix)
        
        
        //Inicializar variaveis de começo e fim.
        let goalNode = Path_Node()
        goalNode.moveCost = 0
        goalNode.mapX = toX
        goalNode.mapY = toY
        
        let rootNode = Path_Node()
        rootNode.moveCost = 0
        rootNode.mapX = fromX
        rootNode.mapY = fromY
        
        openList.enqueue(rootNode)
        
        //Preencher matriz com os custos de cada tile.
        while(!openList.isEmpty())
        {
            let node = openList.dequeue()
            //            if(node?.mapX == goalNode.mapX && node?.mapY == goalNode.mapY)
            //            {
            //                break;
            //            }
            
            var adjacentTiles = getAdjacentTilesZero(node!, goalNode: goalNode, map: binaryMat)
            if(adjacentTiles.count <= 0)
            {
                continue
            }
            
            for i in 0...adjacentTiles.count-1
            {
                let x = adjacentTiles[i].mapX
                let y = adjacentTiles[i].mapY
                
                binaryMat[y][x] = adjacentTiles[i].moveCost
                openList.enqueue(adjacentTiles[i])
            }
        }
        
        //Limpar lista aberta.
        while !openList.isEmpty()
        {
            openList.dequeue()
        }
        
        //Setar valores para que possa arranjar o caminho inverso.
        openList.enqueue(goalNode)
        binaryMat[goalNode.mapY][goalNode.mapX] = -3
        binaryMat[rootNode.mapY][rootNode.mapX] = 0
        finalList.enqueue(goalNode)
        

        
        while(!openList.isEmpty())
        {
            let node = openList.dequeue()
            if(node?.mapX == rootNode.mapX && node?.mapY == rootNode.mapY)
            {
                break
            }
            let adjacentNodes = getAdjacentTiles(node!, goalNode: rootNode, map: binaryMat)
            if(adjacentNodes.count > 0)
            {
                var minCheck = Path_Node()
                minCheck.moveCost = -1;
                for i in 0..<adjacentNodes.count
                {
                    if(minCheck.moveCost <= -1)
                    {
                        minCheck = adjacentNodes[i]
                    }
                    
                    if(adjacentNodes[i].moveCost < minCheck.moveCost)
                    {
                        minCheck = adjacentNodes[i]
                    }
                }
                
                if(minCheck.moveCost != -1)
                {
                    finalList.enqueue(minCheck)
                    binaryMat[minCheck.mapY][minCheck.mapX] = -2
                    openList.enqueue(minCheck)
                }
            }
            else if(!finalList.isEmpty())
            {
                let back = finalList.dequeue()
                binaryMat[node!.mapY][node!.mapX] = -99
                openList.enqueue(back!)
            }
            
        }
        

        
        //Inverter lista
        var returnList = [Path_Node]()
        while(!finalList.isEmpty())
        {
            returnList.append(finalList.dequeue()!)
        }
        
        for i in (0...returnList.count-1).reverse()
        {
            finalList.enqueue(returnList[i])
        }
        
        return finalList
        
    }
    
    
    func getAdjacentTilesZero(node: Path_Node,goalNode: Path_Node,map:[[Int]]) -> [Path_Node]
    {
        var adjacentTiles = [Path_Node]()
        //Pegando o tile de cima.
        if(node.mapY-1 >= 0 && map[node.mapY-1][node.mapX] == 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = node.moveCost+1
            newNode.mapX = node.mapX
            newNode.mapY = node.mapY-1
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile de baixo.
        if(node.mapY+1 < map.count && map[node.mapY+1][node.mapX] == 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = node.moveCost+1
            newNode.mapX = node.mapX
            newNode.mapY = node.mapY+1
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile do lado direito.
        if(node.mapX+1 < map[0].count && map[node.mapY][node.mapX+1] == 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = node.moveCost+1
            newNode.mapX = node.mapX+1
            newNode.mapY = node.mapY
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile do lado esquerda.
        if(node.mapX-1 >= 0 && map[node.mapY][node.mapX-1] == 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = node.moveCost+1
            newNode.mapX = node.mapX-1
            newNode.mapY = node.mapY
            adjacentTiles.append(newNode)
        }
        
        return adjacentTiles
    }
    
    
    func getAdjacentTiles(node: Path_Node,goalNode: Path_Node,map:[[Int]]) -> [Path_Node]
    {
        var adjacentTiles = [Path_Node]()
        //Pegando o tile de cima.
        if(node.mapY-1 >= 0 && map[node.mapY-1][node.mapX] >= 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = map[node.mapY-1][node.mapX]
            newNode.mapX = node.mapX
            newNode.mapY = node.mapY-1
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile de baixo.
        if(node.mapY+1 < map.count && map[node.mapY+1][node.mapX] >= 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = map[node.mapY+1][node.mapX]
            newNode.mapX = node.mapX
            newNode.mapY = node.mapY+1
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile do lado direito.
        if(node.mapX+1 < map[0].count && map[node.mapY][node.mapX+1] >= 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = map[node.mapY][node.mapX+1]
            newNode.mapX = node.mapX+1
            newNode.mapY = node.mapY
            adjacentTiles.append(newNode)
        }
        
        //Pegando o tile do lado esquerda.
        if(node.mapX-1 >= 0 && map[node.mapY][node.mapX-1] >= 0)
        {
            let newNode = Path_Node()
            newNode.moveCost = map[node.mapY][node.mapX-1]
            newNode.mapX = node.mapX-1
            newNode.mapY = node.mapY
            adjacentTiles.append(newNode)
        }
        return adjacentTiles
    }
    
    public func convertMatrixToBinary(mat:[[Int]]) -> [[Int]]
    {
        var nMat = mat
        for x in 0...mat.count-1
        {
            for y in 0...mat[0].count-1
            {
                if(mat[y][x] != 0 && mat[y][x] != 4)
                {
                    nMat[y][x] = -99
                }
                else if(mat[y][x] == 4)
                {
                    nMat[y][x] = 0
                }
            }
        }
        
        return nMat
    }
}