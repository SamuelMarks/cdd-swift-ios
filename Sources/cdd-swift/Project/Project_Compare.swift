//
//  Project_Compare.swift
//  cdd-swift
//
//  Created by Alexei on 14/07/2019.
//


extension Project {
    func compare(_ oldProject: Project) -> [Changes] {
        let project = self
        var projectChanges: [Changes] = []
        let models = project.models
        var oldModels = oldProject.models
        
        for model in models {
            if let index = oldModels.firstIndex(where: {$0.name == model.name}) {
                let oldModel = oldModels[index]
                let changes = model.compare(to: oldModel)
                if changes.count > 0 {
                    projectChanges.append(contentsOf: changes.map { .update(.model(model, $0))})
                }
                oldModels.remove(at: index)
                
            }
            else {
                projectChanges.append(.insertion(.model(model, nil)))
            }
            
        }
        projectChanges.append(contentsOf:oldModels.map {Changes.deletion(.model($0,nil))})
        
        let requests = project.requests
        var oldRequests = oldProject.requests
        for request in requests {
            if let index = oldRequests.firstIndex(where: {$0.name == request.name}) {
                let oldRequest = oldRequests[index]
                let changes = request.compare(to: oldRequest)
                if changes.count > 0 {
                    projectChanges.append(contentsOf: changes.map { .update(.request(request, $0))})
                }
                oldRequests.remove(at: index)
            }
            else {
                projectChanges.append(.insertion(.request(request, nil)))
            }
        }
        projectChanges.append(contentsOf:oldRequests.map {Changes.deletion(.request($0,nil))})
        return projectChanges
    }
    
   
}

extension SwaggerSpec {
    mutating func apply(_ changes: [Changes]) {
        for change in changes {
            switch change {
            case .insertion(_):
                break
            case .deletion(let object):
                switch object {
                case .model(let model, _):
                    if let needToDeleteIndex = self.components.schemas.firstIndex(where: {$0.name == model.name}) {
                        self.components.schemas.remove(at: needToDeleteIndex)
                    }
                    
                case .request(let request, _):
                    break
                }
                
            case .update(_):
                break
            }
        }
    }
}
