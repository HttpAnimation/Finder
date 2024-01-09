import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONObject;

public class Finder {

    public static void main(String[] args) {
        try {
            // Read the Repos.json file
            String configFile = "Configs/Repos.json";
            String reposJson = readConfigFile(configFile);

            // Parse the JSON array
            JSONArray reposArray = new JSONArray(reposJson);

            // Iterate through each repository
            for (int i = 0; i < reposArray.length(); i++) {
                JSONObject repoObject = reposArray.getJSONObject(i);

                // Extract the URL from the repository JSON
                String repoUrl = repoObject.getString("Repo-1");

                // Fetch data from the repository URL
                String repoData = fetchDataFromURL(repoUrl);

                // Parse the repository data JSON
                JSONObject repoDataObject = new JSONObject(repoData);

                // Print the repository information
                System.out.println("Name: " + repoDataObject.getString("Name"));
                System.out.println("Description: " + repoDataObject.getString("Description"));
                System.out.println("Developer: " + repoDataObject.getString("Developer"));
                System.out.println("Install Command: " + repoDataObject.getString("Install-Command"));
                System.out.println("Remove Command: " + repoDataObject.getString("Remove-Command"));
                System.out.println("Run Command: " + repoDataObject.getString("Run-Command"));
                System.out.println("Logo: " + repoDataObject.getString("Logo"));
                System.out.println("Project: " + repoDataObject.getString("Project"));
                System.out.println("\n---\n");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static String readConfigFile(String filePath) throws IOException {
        StringBuilder content = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(
                Finder.class.getClassLoader().getResourceAsStream(filePath)))) {
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
        }
        return content.toString();
    }

    private static String fetchDataFromURL(String urlString) throws IOException {
        URL url = new URL(urlString);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            StringBuilder content = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
            return content.toString();
        } finally {
            connection.disconnect();
        }
    }
}
