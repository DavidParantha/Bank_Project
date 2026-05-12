import org.yaml.snakeyaml.Yaml;
import java.io.FileInputStream;
import java.util.Map;

public class TestYaml {
    public static void main(String[] args) throws Exception {
        Yaml yaml = new Yaml();
        Map<String, Object> data = yaml.load(new FileInputStream("c:\\Users\\Hemant\\Ace-bank-lit\\src\\main\\resources\\sql\\queries.yaml"));
        Map<String, Object> user = (Map<String, Object>) data.get("user");
        System.out.println("get_password_by_acc: [" + user.get("get_password_by_acc") + "]");
    }
}
