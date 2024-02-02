import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslateApp {
  final RxString idiomaCode = 'pt_BR'.obs;
  Locale? locale;
  String get lang => idiomaCode.value;

  setLang() async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      String? lang = storage.getString('lang');

      if (lang != null) {
        idiomaCode.value = lang.toString();
      } else {
        idiomaCode.value = Get.deviceLocale.toString();
      }
      idiomaCode.refresh();

      var array = lang!.split('_');

      await changeLang(array[0], array[1]);

      // ignore: empty_catches
    } catch (e) {}
  }

  changeLang(key, country) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();

      Get.addTranslations(AppTranslation.translationsKeys);
      idiomaCode.value = '${key}_$country';
      idiomaCode.refresh();

      locale = Locale(key, country);
      await Get.updateLocale(locale!);
      await storage.setString('lang', idiomaCode.value);

      // ignore: empty_catches
    } catch (e) {}
    Get.back();
  }

  showLangs() async {
    var childrens = List<Widget>.empty(growable: true);
    for (var i = 0; i < AppTranslation.listLangs.length; i++) {
      Map<String, String> element = AppTranslation.listLangs[i];
      childrens.add(
        ListTile(
          onTap: () => {
            changeLang(element['key'], element['country']),
          },
          leading: const SizedBox(
              width: 25.0, height: 25.0, child: Icon(Icons.language_outlined)),
          title: Text(
            element['name'].toString().tr,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.arrow_right_outlined),
        ),
      );
    }
    Get.back();

    Get.bottomSheet(
      CupertinoActionSheet(
        actions: childrens,
      ),
    );
  }
}

abstract class AppTranslation extends Translations {
  static Map<String, Map<String, String>> translationsKeys = {
    "pt_BR": ptBR,
    "en_US": enUS,
    "es_ES": esES,
  };

  static List<Map<String, String>> listLangs = [
    {"name": "portuguese", "key": "pt", "country": "BR"},
    {"name": "english", "key": "en", "country": "US"},
    {"name": "spanish", "key": "es", "country": "ES"},
  ];
}

final Map<String, String> ptBR = {
  "portuguese": "Português",
  "english": "Inglês",
  "spanish": "Espanhol",
  "texto_copiado": "Texto copiado",
  "texto_copiado_info": "O seu Texto foi copiada com sucesso",
  "hash_copiada": "Hash copiada",
  "hash_copiada_info": "A sua hash foi copiada com sucesso",
  "arquivo_vazio": "Arquivo vazio",
  "arquivo_vazio_info": "Informe o seu arquivo",
  "senha_vazia": "Senha vazia",
  "senha_vazia_info": "Informe a sua senha",
  "hash_vazia": "Hash vazia",
  "hash_vazia_info": "Informe a sua hash",
  "erro_descriptografar": "Erro ao descriptografar",
  "erro_descriptografar_info": "Não foi possível descriptografar",
  "erro_criptografar": "Erro ao criptografar",
  "erro_criptografar_info": "Não foi possível criptografar",
  "selecionar_arquivo": "selecionar arquivo",
  "digite_senha": "Digite sua senha aqui",
  "digite_hash": "Digite sua hash aqui",
  "digite_texto": "Digite seu texto aqui",
  "descriptografar": "Descriptografar",
  "criptografar": "Criptografar",
  "copiar": "Copiar",
  "salvar_texto": "Salvar Texto",
  "salvar_texto_info": "Erro ao salvar o texto",
  "armazenar_em_arquivo": "Armazenar em arquivo",
  "texto_vazio": "Texto vazio",
  "texto_vazio_info": "Informe o seu texto",
  "about": "Sobre",
  "proposito": "Propósito do Aplicativo:",
  "proposito_info":
      "Este Aplicativo tem como único propósito oferecer funcionalidades de criptografia e descriptografia de senhas relacionadas a carteiras Bitcoin ou qualquer texto.",
  "funcionalidades": "Funcionalidades Principais:",
  "funcionalidades_info":
      "O aplicativo permite que você criptografe suas senhas de carteira Bitcoin para maior segurança. Oferece a funcionalidade de descriptografar carteiras Bitcoin ou qualquer texto previamente criptografadas.",
  "internet": "Acesso à Internet:",
  "internet_info":
      "Este aplicativo não requer acesso à internet para suas funcionalidades. Nenhuma informação é transmitida pela internet durante o processo de criptografia ou descriptografia.",
  "open_source": "Código Aberto (Open Source):",
  "open_source_info":
      "Este Aplicativo é um software de código aberto, o que significa que o código-fonte do aplicativo está disponível publicamente. Encorajamos a revisão do código por parte dos usuários para garantir transparência e confiança.",
  "responsabilidades": "Responsabilidades do Usuário:",
  "responsabilidades_info":
      "Os usuários são responsáveis por manter a confidencialidade de suas senhas e informações relacionadas à carteira Bitcoin ou qualquer texto. Recomendamos o uso de senhas fortes e práticas de segurança adequadas.",
  "perda_senha": "Recuperação de Senha:",
  "perda_senha_info":
      "É importante observar que, em caso de perda da senha, não há meios de recuperar as chaves da sua carteira Bitcoin ou qualquer texto criptografado",
  "feito_flutter":
      "Este aplicativo foi desenvolvido utilizando o framework Flutter.",
  "feito_flutter_info":
      "Este aplicativo, desenvolvido em Flutter, incorpora a funcionalidade de criptografia por meio das bibliotecas encrypt.dart e cryptography.dart."
};
final Map<String, String> enUS = {
  "portuguese": "Portuguese",
  "english": "English",
  "spanish": "Spanish",
  "texto_copiado": "Copied Text",
  "texto_copiado_info": "Your text has been copied successfully",
  "hash_copiada": "Copied Hash",
  "hash_copiada_info": "Your hash has been copied successfully",
  "arquivo_vazio": "Empty File",
  "arquivo_vazio_info": "Please provide your file",
  "senha_vazia": "Empty Password",
  "senha_vazia_info": "Please provide your password",
  "hash_vazia": "Empty Hash",
  "hash_vazia_info": "Please provide your hash",
  "erro_descriptografar": "Error Decrypting",
  "erro_descriptografar_info": "Unable to decrypt",
  "erro_criptografar": "Error Encrypting",
  "erro_criptografar_info": "Unable to encrypt",
  "selecionar_arquivo": "Select File",
  "digite_senha": "Enter your password here",
  "digite_hash": "Enter your hash here",
  "digite_texto": "Enter your text here",
  "descriptografar": "Decrypt",
  "criptografar": "Encrypt",
  "copiar": "Copy",
  "salvar_texto": "Save Text",
  "salvar_texto_info": "Error saving the text",
  "armazenar_em_arquivo": "Store in File",
  "texto_vazio": "Empty Text",
  "texto_vazio_info": "Please provide your text",
  "about": "About",
  "proposito": "Purpose of the Application:",
  "proposito_info":
      "This application has the sole purpose of providing functionalities for encrypting and decrypting passwords related to Bitcoin wallets or any text.",
  "funcionalidades": "Key Features:",
  "funcionalidades_info":
      "The application allows you to encrypt your Bitcoin wallet passwords for increased security. It provides the functionality to decrypt previously encrypted Bitcoin wallets or any text.",
  "internet": "Internet Access:",
  "internet_info":
      "This application does not require internet access for its functionalities. No information is transmitted over the internet during the encryption or decryption process.",
  "open_source": "Open Source Code:",
  "open_source_info":
      "This application is open-source software, meaning that the source code is publicly available. We encourage users to review the code for transparency and trust.",
  "responsabilidades": "User Responsibilities:",
  "responsabilidades_info":
      "Users are responsible for maintaining the confidentiality of their passwords and information related to the Bitcoin wallet or any text. We recommend the use of strong passwords and appropriate security practices.",
  "perda_senha": "Password Recovery:",
  "perda_senha_info":
      "It is important to note that, in the event of password loss, there is no way to recover the keys to your Bitcoin wallet or any encrypted text.",
  "feito_flutter":
      "This application was developed using the Flutter framework.",
  "feito_flutter_info":
      "Built in Flutter, this application incorporates encryption functionality through the encrypt.dart and cryptography.dart libraries."
};

final Map<String, String> esES = {
  "portuguese": "Portugués",
  "english": "Inglés",
  "spanish": "Español",
  "texto_copiado": "Texto copiado",
  "texto_copiado_info": "Tu texto ha sido copiado exitosamente",
  "hash_copiada": "Hash copiado",
  "hash_copiada_info": "Tu hash ha sido copiada exitosamente",
  "arquivo_vazio": "Archivo vacío",
  "arquivo_vazio_info": "Por favor, proporciona tu archivo",
  "senha_vazia": "Contraseña vacía",
  "senha_vazia_info": "Por favor, proporciona tu contraseña",
  "hash_vazia": "Hash vacía",
  "hash_vazia_info": "Por favor, proporciona tu hash",
  "erro_descriptografar": "Error al desencriptar",
  "erro_descriptografar_info": "No se puede desencriptar",
  "erro_criptografar": "Error al encriptar",
  "erro_criptografar_info": "No se puede encriptar",
  "selecionar_arquivo": "Seleccionar archivo",
  "digite_senha": "Ingresa tu contraseña aquí",
  "digite_hash": "Ingresa tu hash aquí",
  "digite_texto": "Ingresa tu texto aquí",
  "descriptografar": "Desencriptar",
  "criptografar": "Encriptar",
  "copiar": "Copiar",
  "salvar_texto": "Guardar texto",
  "salvar_texto_info": "Error al guardar el texto",
  "armazenar_em_arquivo": "Almacenar en archivo",
  "texto_vazio": "Texto vacío",
  "texto_vazio_info": "Por favor, proporciona tu texto",
  "about": "Acerca de",
  "proposito": "Propósito de la Aplicación:",
  "proposito_info":
      "Esta aplicación tiene como único propósito ofrecer funcionalidades de cifrado y descifrado de contraseñas relacionadas con carteras de Bitcoin o cualquier texto.",
  "funcionalidades": "Funcionalidades Clave:",
  "funcionalidades_info":
      "La aplicación te permite cifrar las contraseñas de tu cartera de Bitcoin para mayor seguridad. Ofrece la funcionalidad de descifrar carteras de Bitcoin o cualquier texto previamente cifrado.",
  "internet": "Acceso a Internet:",
  "internet_info":
      "Esta aplicación no requiere acceso a Internet para sus funcionalidades. No se transmite información por Internet durante el proceso de cifrado o descifrado.",
  "open_source": "Código Fuente Abierto:",
  "open_source_info":
      "Esta aplicación es un software de código abierto, lo que significa que el código fuente está disponible públicamente. Alentamos a los usuarios a revisar el código para mayor transparencia y confianza.",
  "responsabilidades": "Responsabilidades del Usuario:",
  "responsabilidades_info":
      "Los usuarios son responsables de mantener la confidencialidad de sus contraseñas e información relacionada con la cartera de Bitcoin o cualquier texto. Recomendamos el uso de contraseñas fuertes y prácticas de seguridad adecuadas.",
  "perda_senha": "Recuperación de Contraseña:",
  "perda_senha_info":
      "Es importante tener en cuenta que, en caso de pérdida de la contraseña, no hay forma de recuperar las claves de tu cartera de Bitcoin o cualquier texto cifrado.",
  "feito_flutter":
      "Esta aplicación fue desarrollada utilizando el marco de trabajo Flutter.",
  "feito_flutter_info":
      "Desarrollada en Flutter, esta aplicación incorpora funcionalidades de cifrado a través de las bibliotecas encrypt.dart y cryptography.dart."
};
