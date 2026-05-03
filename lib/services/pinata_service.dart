import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class PinataService {
  final String _pinataUrl = 'https://api.pinata.cloud/pinning/pinFileToIPFS';

  /// RF-01: Sube un archivo físico (foto de perfil, documento) a Pinata (IPFS)
  /// Retorna el CID (Hash de IPFS) si fue exitoso, o null en caso de error.
  Future<String?> uploadFileToIPFS(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_pinataUrl));

      // Añadir Headers de autenticación
      request.headers.addAll({
        'Authorization': 'Bearer \${EnvConfig.pinataJwt}',
      });

      // Adjuntar el archivo
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Enviar la petición
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var json = jsonDecode(responseString);

        return json['IpfsHash']; // Retorna el CID para guardarlo en Supabase
      } else {
        print('Error subiendo a Pinata: \${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción en PinataService: \$e');
      return null;
    }
  }

  /// URL de ayuda para visualizar archivos IPFS subidos
  String getIPFSUrl(String cid) {
    return 'https://gateway.pinata.cloud/ipfs/\$cid';
  }
}
