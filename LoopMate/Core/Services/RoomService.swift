//
//  RoomService.swift
//  LoopMate
//
//  Created by 平石悠生 on 2026/03/15.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class RoomService {
    
    private let db = Firestore.firestore()
    
    func createRoom(
        name: String,
        isNumberRequired: Bool,
        isPhotoRequired: Bool,
        startDate: Date,
        endDate: Date?,
        selectedWeekdays: [Bool],
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(RoomServiceError.userNotSignedIn))
            return
        }
        
        let roomRef = db.collection("rooms").document()
        let roomId = roomRef.documentID
        let now = Timestamp(date: Date())
        let roomCode = Self.generateRoomCode()
        
        let roomData: [String: Any] = [
            "name": name,
            "code": roomCode,
            "ownerUid": uid,
            "createdAt": now,
            "updatedAt": now,
            "memberCount": 1,
            "isNumberRequired": isNumberRequired,
            "isPhotoRequired": isPhotoRequired,
            "startDate": Timestamp(date: startDate),
            "endDate": endDate.map { Timestamp(date: $0) } as Any,
            "selectedWeekdays": selectedWeekdays
        ]
        
        let memberDocId = "\(roomId)_\(uid)"
        
        let memberData: [String: Any] = [
            "roomId": roomId,
            "uid": uid,
            "role": "owner",
            "joinedAt": now
        ]
        
        let batch = db.batch()
        batch.setData(roomData, forDocument: roomRef)
        batch.setData(memberData, forDocument: db.collection("roomMembers").document(memberDocId))
        
        batch.commit { error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(roomId))
            }
        }
    }
    
    private static func generateRoomCode(length: Int = 5) -> String {
        let characters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        return String((0..<length).compactMap { _ in characters.randomElement() })
    }
    
    // 自分の所属ルーム一覧を取得する関数
    func fetchMyRooms(completion: @escaping (Result<[Room], Error>) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(RoomServiceError.userNotSignedIn))
            return
        }
        
        db.collection("roomMembers")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let roomIds = documents.compactMap { $0.data()["roomId"] as? String }
                
                if roomIds.isEmpty {
                    completion(.success([]))
                    return
                }
                
                self.fetchRooms(by: roomIds, completion: completion)
            }
    }
    
    // roomId 配列から rooms を取得する関数
    private func fetchRooms(
        by roomIds: [String],
        completion: @escaping (Result<[Room], Error>) -> Void
    ) {
        let group = DispatchGroup()
        var rooms: [Room] = []
        var fetchError: Error?
        
        for roomId in roomIds {
            group.enter()
            
            db.collection("rooms").document(roomId).getDocument { snapshot, error in
                defer { group.leave() }
                
                if let error {
                    fetchError = error
                    return
                }
                
                guard
                    let snapshot,
                    let data = snapshot.data()
                else {
                    return
                }
                
                guard
                    let name = data["name"] as? String,
                    let code = data["code"] as? String,
                    let memberCount = data["memberCount"] as? Int,
                    let ownerUid = data["ownerUid"] as? String,
                    let createdAt = data["createdAt"] as? Timestamp,
                    let updatedAt = data["updatedAt"] as? Timestamp,
                    let isNumberRequired = data["isNumberRequired"] as? Bool,
                    let isPhotoRequired = data["isPhotoRequired"] as? Bool,
                    let startDate = data["startDate"] as? Timestamp,
                    let selectedWeekdays = data["selectedWeekdays"] as? [Bool]
                else {
                    return
                }
                
                let endDate = data["endDate"] as? Timestamp
                
                let room = Room(
                    id: snapshot.documentID,
                    name: name,
                    code: code,
                    memberCount: memberCount,
                    ownerUid: ownerUid,
                    createdAt: createdAt,
                    updatedAt: updatedAt,
                    isNumberRequired: isNumberRequired,
                    isPhotoRequired: isPhotoRequired,
                    startDate: startDate,
                    endDate: endDate,
                    selectedWeekdays: selectedWeekdays,
                    progress: 0
                )
                
                rooms.append(room)
            }
        }
        
        group.notify(queue: .main) {
            if let fetchError {
                completion(.failure(fetchError))
            } else {
                let sortedRooms = rooms.sorted {
                    $0.createdAt.dateValue() > $1.createdAt.dateValue()
                }
                completion(.success(sortedRooms))
            }
        }
    }
    
    // 単一ルーム取得
    func fetchRoom(roomId: String, completion: @escaping (Result<Room, Error>) -> Void) {
        db.collection("rooms").document(roomId).getDocument { snapshot, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard
                let snapshot,
                let data = snapshot.data()
            else {
                completion(.failure(RoomServiceError.roomNotFound))
                return
            }
            
            guard
                let name = data["name"] as? String,
                let code = data["code"] as? String,
                let memberCount = data["memberCount"] as? Int,
                let ownerUid = data["ownerUid"] as? String,
                let createdAt = data["createdAt"] as? Timestamp,
                let updatedAt = data["updatedAt"] as? Timestamp,
                let isNumberRequired = data["isNumberRequired"] as? Bool,
                let isPhotoRequired = data["isPhotoRequired"] as? Bool,
                let startDate = data["startDate"] as? Timestamp,
                let selectedWeekdays = data["selectedWeekdays"] as? [Bool]
            else {
                completion(.failure(RoomServiceError.invalidRoomData))
                return
            }
            
            let endDate = data["endDate"] as? Timestamp
            
            let room = Room(
                id: snapshot.documentID,
                name: name,
                code: code,
                memberCount: memberCount,
                ownerUid: ownerUid,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isNumberRequired: isNumberRequired,
                isPhotoRequired: isPhotoRequired,
                startDate: startDate,
                endDate: endDate,
                selectedWeekdays: selectedWeekdays,
                progress: 0
            )
            
            completion(.success(room))
        }
    }
}

enum RoomServiceError: Error {
    case userNotSignedIn
    case roomNotFound
    case invalidRoomData
}
