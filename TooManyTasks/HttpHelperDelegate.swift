import Foundation

protocol HttpHelperDelegate {
    func onSuccess(data: [String: Any])
    func onFail()
    func onFinish()
}
