import UIKit

protocol Message {
    var messageString: String { get set }
    init(messageString: String)
    func prepareMessage()
}

protocol Sender {
    func sendMessage(message: Message)
}

class PlainTextMessage: Message {
    var messageString: String = ""
    
    required init(messageString: String) {
        self.messageString = messageString
    }
    
    func prepareMessage() {
        // từ từ
    }

}

class DESEncryptedMessage: Message {
    var messageString: String = ""
    
    required init(messageString: String) {
        self.messageString = messageString
    }
    
    func prepareMessage() {
        //Encrypt message
        
        self.messageString = "Encrypted: \(self.messageString)"
    }
}

class EmailSender: Sender {
    func sendMessage(message: Message) {
        print("Sending email: \(message.messageString)")
    }
}

class SMSSender: Sender {
    func sendMessage(message: Message) {
        print("Sending SMS: \(message.messageString)")
    }
}
var myMess = PlainTextMessage(messageString: "Plain Text Messag")
myMess.prepareMessage()

var sender = SMSSender()
sender.sendMessage(message: myMess)
// giả sử sender có thêm yêu cầu mới
protocol NewSender {
    var message: Message? { get set }
    func sendMessage()
    func verifyMessage()
}

class NewEmailSender: NewSender {
    
    
    var message: Message?
    
    func sendMessage() {
        print("Sending email: \(message)")

    }
    func verifyMessage() {
        print("Verifying E-Mail message")
    }
}
class NewSMSSender: NewSender {
    var message: Message?
    func sendMessage() {
        print("Sending through SMS:")
        print(" \(message!.messageString)")
    }
    func verifyMessage() {
        print("Verifying SMS message")
    }
}
var myMessage = PlainTextMessage(messageString: "Plain Text Message")
myMessage.prepareMessage()
var newSender = NewSMSSender()
newSender.message = myMessage
newSender.verifyMessage()
// nghĩa là, khi có sự thay đổi yêu cầu logic từ 1 bên, thì các đối tượng được gọi để thực thi cung phải thay đổi
//để tránh được trường hợp phải thay đổi hết tất cả các đối tượng thực thi, thì Brigdge ra đời, chỉ cần sửa duy nhất ở Bridge
struct MessagingBridge {
    static func sendMessage(message: Message, sender: NewSender) {
        var sender = sender
        message.prepareMessage()
        sender.message = message
        sender.verifyMessage()
        sender.sendMessage()
    }
}
