
import UIKit

class Main: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var MemoData = [String]() 

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK : Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 지정된 섹션의 행 (테이블 셀) 수를 반환
        MemoData = UserDefaults.standard.object(forKey: "MemoData") as? [String] ?? [String]()
        // MemoData에 값이 있다면 불러오고 없다면 빈껍데기 생성
        
        return MemoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀이 테이블 뷰의 특정 위치에 삽입되도록 데이터 소스에 요청
        let Cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainCell
        // MainCell에서 불러온 Cell
        
        MemoData = UserDefaults.standard.object(forKey: "MemoData") as? [String] ?? [String]()
        // MemoData가 있다면 MemoData를 불러오고 없으면 빈껍데기 생성
        Cell.TitleLabel.text = MemoData[indexPath.row] // 메모가 저장된 행의 MemoData를 제목으로 사용

        return Cell
    } // 리스트를 꾸며주는 부분
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 지정한 행이 현재 선택되었다고 델리게이트에게 알림
        let MemoNumber = indexPath.row
        UserDefaults.standard.set(MemoNumber, forKey: "MemoNumber") // MemoNumber를 MemoNumber 이름으로 저장
        
        self.performSegue(withIdentifier: "ToRecord", sender: self) // 선택한 행의 뷰로 이동
    }
    // Table_End

    
    // MARK : Action
    @IBAction func Add(_ sender: Any) { // 텍스트메모로 이동하는 버튼
        UserDefaults.standard.set(-1, forKey: "MemoNumber") // -1은 추가하는 의미
    }
    
    @IBAction func ArtAdd(_ sender: Any) { // 그림메모로 이동하는 버튼
        UserDefaults.standard.set(-1, forKey: "MemoNumber")
    }
    // Action_End
}

