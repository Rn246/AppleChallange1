import Foundation
let caminho = createPath().path
var tarefasDecoded: (toConclude:[Tarefa], concluded:[Tarefa]) = loadTask(from: caminho)
var Tasks: [Tarefa] = tarefasDecoded.toConclude
var TasksConcluded: [Tarefa] = tarefasDecoded.concluded

print (Tasks)

struct Tarefas: Codable {
    var taskstoConclude: [Tarefa] = []
    var tasksConcluded: [Tarefa] = []
}

struct Tarefa: Codable {
    var name: String
    var description: String
}

func createPath () -> URL {
let fileManager = FileManager.default
do {
    let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    let fileURL = documentsURL.appendingPathComponent("listatarefas.json")
    return fileURL // imprime o caminho completo para o arquivo
       } catch {
    fatalError("Erro ao encontrar o caminho do arquivo: \(error)")
   }
}

func loadTask(from filePath: String) -> ([Tarefa], [Tarefa]) {
    let fileURL = URL(fileURLWithPath: filePath)
      let decoder = JSONDecoder()
    do {
        let jsonData = try Data(contentsOf: fileURL)
   let tarefa = try decoder.decode(Tarefas.self, from: jsonData)
        return (tarefa.taskstoConclude, tarefa.tasksConcluded) }
    catch{
        print("Erro ao carregar a lista!")
        return ([], [])
    }
 }


 func saveTask() {
   let fileURL = URL(fileURLWithPath: caminho)
   let encoder = JSONEncoder()
     do {
     let jsonData = try encoder.encode(Tarefas(taskstoConclude: Tasks,
                                               tasksConcluded: TasksConcluded))
         try jsonData.write(to: fileURL) }
     catch {
         print("Erro ao salvar na lista")
     }

}



var opcao = 0
var aux = 0

repeat {
  print("\n---------------------------------- Menu Inicial ----------------------------------\nSeja Bem-Vindo(a) ao gereacionamento de tarefas\nDigite 9 para encerrar o sistema e qualquer outro número para continuar:")
    print("Aviso: Para salvar suas alterações, encerre o programa (Digite 9) no Menu Principal")
    if let input = readLine(), let inputValue = Int(input) {
  aux = inputValue
  if (aux == 9) { print ("Programa encerrado, tenha um bom dia")}
  else {
    print("\n--------------------------------- Menu Principal ---------------------------------\nO que desejas fazer?\nDigite 9 para encerrar o programa!\nDigite 1 para adicionar uma tarefa: \nDigite 2 para marcar uma tarefa como concluida:\nDigite 3 para encontrar uma tarefa:\nDigite 4 para listar todas as tarefas:\nDigite 5 para editar uma tarefa:\nDigite 6 para remover tarefas: ")
      print("Lembre-se: para salvar as alterações feitas, encerre o programa corretamente\n")
  opcao = ((Int(readLine()!)!))
    switch opcao {
      case 9:
        saveTask()
        print ("Programa encerrado, tenha um bom dia")
        aux = 9
        break
      case 1:
        print("\n")
        Adicionar()
        break
      case 2:
        print("\n")
        Concluir()
        break
      case 3:
        print("\n")
        Encontrar()
        break
      case 4:
        print("\n")
        Listar()
        break
      case 5:
        print("\n")
        Editar()
        break
      case 6:
        print("\n")
        Remover()
        break
      default:
        print("\n")
       print("Opação invalida")
    }
  }
    } else {
        print("Digite um valor válido")
    }
} while (aux != 9)



func Adicionar () {
    print("Informe o nome da tarefa:")
    guard let nomeTarefa = readLine() else {
        print("Digite uma tarefa")
        return
    }
    print("Informe a descrição da tarefa:")
    guard let descricaoTarefa = readLine() else {return}
    let novaTarefa = Tarefa(name: nomeTarefa, description: descricaoTarefa)
    Tasks.append(novaTarefa)
    Listar()
    print("\nLembre-se de salvar as suas alterações no Menu Principal!")
}


func Concluir (){
    print ("Digite o nome da tarefa concluida:")
    
    guard let nomeTarefaCon = readLine() else {
        print("Digite uma tarefa")
        return
    }
    
    guard let index = Tasks.firstIndex(where: { $0.name == nomeTarefaCon })
    else {
        print("Tarefa não encontrada")
        return
    }
    
    let tarefaconcluida = Tasks[index]
    
    Tasks.remove(at: index)
    
    TasksConcluded.append(tarefaconcluida)
    
    Listar()
    
    print("\nLembre-se de salvar as suas alterações no Menu Principal!")
}

func Encontrar() {
        print("Digite uma palavra para procurar nas listas:")
        guard let alvo = readLine() else {
            print("\nDigite algo")
            return
        }
        
        var foundTasks: [Tarefa] = []
        var foundConcludedTasks: [Tarefa] = []
        
        for task in Tasks {
            if task.name.contains(alvo) || task.description.contains(alvo) {
                foundTasks.append(task)
            }
        }
        
        for task in TasksConcluded {
            if task.name.contains(alvo) || task.description.contains(alvo) {
                foundConcludedTasks.append(task)
            }
        }
        
        if !foundTasks.isEmpty {
            print("Tarefas encontradas na lista de tarefas a concluir:")
            for (index, task) in foundTasks.enumerated() {
                print("Tarefa \(index + 1):")
                print("Nome: \(task.name)")
                print("Descrição: \(task.description)")
                print("-----------------------------")
            }
        } else {
            print("Nenhuma tarefa encontrada na lista de tarefas a concluir.")
        }

        if !foundConcludedTasks.isEmpty {
            print("Tarefas encontradas na lista de tarefas concluídas:")
            for (index, task) in foundConcludedTasks.enumerated() {
                print("Tarefa \(index + 1):")
                print("Nome: \(task.name)")
                print("Descrição: \(task.description)")
                print("-----------------------------")
            }
        } else {
            print("Nenhuma tarefa encontrada na lista de tarefas concluídas.")
        }
        
        print("\nLembre-se de salvar as suas alterações no Menu Principal!")
    }

func Listar (){
    print("Lista de tarefas para concluir:")
        for (index, task) in Tasks.enumerated() {
            print("Tarefa \(index + 1):")
            print("Nome: \(task.name)")
            print("Descrição: \(task.description)")
            print("-----------------------------")
        }
        
        print("Lista de tarefas concluídas:")
        for (index, task) in TasksConcluded.enumerated() {
            print("Tarefa \(index + 1):")
            print("Nome: \(task.name)")
            print("Descrição: \(task.description)")
            print("-----------------------------")
        }
        
}

func Editar() {
    Listar()
    
    print("Digite o título da tarefa que desejas editar:")
    guard let editar = readLine() else{
        print("\nDigite um título")
        return
    }
    
    guard let index = Tasks.firstIndex(where: { $0.name == editar })
    else {
        print("\nTarefa não encontrada")
        return
    }
    
    print("\nDigite o novo título:")
    guard let novo_nome = readLine() else {
        print("\nEspaço em branco")
        return
    }
    
    print("\nDigite o nova descrição:")
    guard let nova_descricao = readLine() else {
        print("\nEspaço em branco")
        return
    }
    
    let tarefa_editada = Tarefa(name: novo_nome, description: nova_descricao)
    
    Tasks.remove(at: index)
    Tasks.append(tarefa_editada)
    
    print("\nLembre-se de salvar as suas alterações no Menu Principal!")
}
    
func Remover () {
    print("Digite o nome da tarefa que desejas remover:")
    guard let eliminar = readLine() else {
        print("\nEspaço em branco!")
        return
    }
    
    guard let index = Tasks.firstIndex(where: { $0.name == eliminar })
    else {
        print("\nTarefa não encontrada")
        return
    }
    
    Tasks.remove(at: index)
    print("\nTarefa removida com sucesso!")
    
    print("\nLembre-se de salvar as suas alterações no Menu Principal!")
}
