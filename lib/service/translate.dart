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
  "copied_text": "Texto copiado",
  "copied_text_info": "O seu Texto foi copiada com sucesso",
  "hash_copied": "Hash copiada",
  "hash_copied_info": "A sua hash foi copiada com sucesso",
  "empty_file": "Arquivo vazio",
  "empty_file_info": "Informe o seu arquivo",
  "empty_password": "Senha vazia",
  "empty_password_info": "Informe a sua senha",
  "empty_hash": "Hash vazia",
  "empty_hash_info": "Informe a sua hash",
  "error_decrypt": "Erro ao descriptografar",
  "error_decrypt_info":
      "Desculpe, a descriptografia não pôde ser concluída. Por favor, verifique a sua senha e tente novamente.",
  "error_encrypt": "Erro ao criptografar",
  "error_encrypt_info": "Não foi possível criptografar",
  "select_file": "selecionar arquivo",
  "enter_password": "Digite sua senha aqui",
  "enter_hash": "Digite sua hash aqui",
  "enter_text": "Digite seu texto aqui",
  "decrypt": "Descriptografar",
  "encrypt": "Criptografar",
  "copy": "Copiar",
  "save_text": "Salvar Texto",
  "save_text_info": "Erro ao salvar o texto",
  "store_in_file": "Armazenar em arquivo",
  "empty_text": "Texto vazio",
  "empty_text_info": "Informe o seu texto",
  "about": "Sobre",
  "purpose": "Propósito do Aplicativo:",
  "purpose_info":
      "Este aplicativo tem como único propósito oferecer funcionalidades de criptografia e descriptografia de senhas relacionadas a carteiras Bitcoin ou qualquer texto. Há também a opção de geração de chaves de 12 ou 24 palavras mnemônicas para criar uma carteira de Bitcoin.",
  "functionalities": "Funcionalidades Principais:",
  "functionalities_info":
      "O aplicativo permite que você criptografe suas senhas de carteira Bitcoin para maior segurança. Oferece a funcionalidade de descriptografar carteiras Bitcoin ou qualquer texto previamente criptografadas.",
  "internet": "Acesso à Internet:",
  "internet_info":
      "Este aplicativo não requer acesso à internet para suas funcionalidades. Nenhuma informação é transmitida pela internet durante o processo de criptografia ou descriptografia.",
  "open_source": "Código Aberto (Open Source):",
  "open_source_info":
      "Este Aplicativo é um software de código aberto, o que significa que o código-fonte do aplicativo está disponível publicamente. Encorajamos a revisão do código por parte dos usuários para garantir transparência e confiança.",
  "responsibilities": "Responsabilidades do Usuário:",
  "responsibilities_info":
      "Os usuários são responsáveis por manter a confidencialidade de suas senhas e informações relacionadas à carteira Bitcoin ou qualquer texto. Recomendamos o uso de senhas fortes e práticas de segurança adequadas.",
  "password_loss": "Recuperação de Senha:",
  "password_loss_info":
      "É importante observar que, em caso de perda da senha, não há meios de recuperar as chaves da sua carteira Bitcoin ou qualquer texto criptografado",
  "created_flutter":
      "Este aplicativo foi desenvolvido utilizando o framework Flutter.",
  "created_flutter_info":
      "Este aplicativo, desenvolvido em Flutter, incorpora a funcionalidade de criptografia por meio das bibliotecas encrypt.dart e cryptography.dart.",
  "generate_keyword_btc":
      "Gere suas palavras-chave para uma carteira de Bitcoin.",
  "choose_number": "Escolha entre 12 palavras ou 24 para sua chave mnemônica.",
  "12words": "12 palavras",
  "24words": "24 palavras",
  "phrase": "Palavras chave",
  "generate_words": "Gerar palavras",
  "terms": "Ao usar esse APP você concorda com nossa politica de privacidade",
};
final Map<String, String> enUS = {
  "portuguese": "Portuguese",
  "english": "English",
  "spanish": "Spanish",
  "copied_text": "Copied Text",
  "copied_text_info": "Your text has been copied successfully",
  "hash_copied": "Copied Hash",
  "hash_copied_info": "Your hash has been copied successfully",
  "empty_file": "Empty File",
  "empty_file_info": "Please provide your file",
  "empty_password": "Empty Password",
  "empty_password_info": "Please provide your password",
  "empty_hash": "Empty Hash",
  "empty_hash_info": "Please provide your hash",
  "error_decrypt": "Error Decrypting",
  "error_decrypt_info":
      "Sorry, decryption could not be completed. Please check your password and try again.",
  "error_encrypt": "Error Encrypting",
  "error_encrypt_info": "Unable to encrypt",
  "select_file": "Select File",
  "enter_password": "Enter your password here",
  "enter_hash": "Enter your hash here",
  "enter_text": "Enter your text here",
  "decrypt": "Decrypt",
  "encrypt": "Encrypt",
  "copy": "Copy",
  "save_text": "Save Text",
  "save_text_info": "Error saving the text",
  "store_in_file": "Store in File",
  "empty_text": "Empty Text",
  "empty_text_info": "Please provide your text",
  "about": "About",
  "purpose": "Purpose of the Application:",
  "purpose_info":
      "This application has the sole purpose of providing functionalities for encrypting and decrypting passwords related to Bitcoin wallets or any text.",
  "functionalities": "Key Features:",
  "functionalities_info":
      "The application allows you to encrypt your Bitcoin wallet passwords for increased security. It provides the functionality to decrypt previously encrypted Bitcoin wallets or any text.",
  "internet": "Internet Access:",
  "internet_info":
      "This application does not require internet access for its functionalities. No information is transmitted over the internet during the encryption or decryption process.",
  "open_source": "Open Source Code:",
  "open_source_info":
      "This application is open-source software, meaning that the source code is publicly available. We encourage users to review the code for transparency and trust.",
  "responsibilities": "User Responsibilities:",
  "responsibilities_info":
      "Users are responsible for maintaining the confidentiality of their passwords and information related to the Bitcoin wallet or any text. We recommend the use of strong passwords and appropriate security practices.",
  "password_loss": "Password Recovery:",
  "password_loss_info":
      "It is important to note that, in the event of password loss, there is no way to recover the keys to your Bitcoin wallet or any encrypted text.",
  "created_flutter":
      "This application was developed using the Flutter framework.",
  "created_flutter_info":
      "Built in Flutter, this application incorporates encryption functionality through the encrypt.dart and cryptography.dart libraries.",
  "generate_keyword_btc": "Generate your keywords for a Bitcoin wallet.",
  "choose_number": "Choose between 12 or 24 words for your mnemonic key.",
  "12words": "12 words",
  "24words": "24 words",
  "phrase": "Mnemonic Phrase",
  "generate_words": "Generate Words",
  "terms": "By using this APP you agree to our privacy policy",
};

final Map<String, String> esES = {
  "portuguese": "Portugués",
  "english": "Inglés",
  "spanish": "Español",
  "copied_text": "Texto copiado",
  "copied_text_info": "Tu texto ha sido copiado exitosamente",
  "hash_copied": "Hash copiado",
  "hash_copied_info": "Tu hash ha sido copiada exitosamente",
  "empty_file": "Archivo vacío",
  "empty_file_info": "Por favor, proporciona tu archivo",
  "empty_password": "Contraseña vacía",
  "empty_password_info": "Por favor, proporciona tu contraseña",
  "empty_hash": "Hash vacía",
  "empty_hash_info": "Por favor, proporciona tu hash",
  "error_decrypt": "Error al desencriptar",
  "error_decrypt_info":
      "Lo siento, la desencriptación no pudo completarse. Por favor, verifica tu contraseña e intenta nuevamente.",
  "error_encrypt": "Error al encriptar",
  "error_encrypt_info": "No se puede encriptar",
  "select_file": "Seleccionar archivo",
  "enter_password": "Ingresa tu contraseña aquí",
  "enter_hash": "Ingresa tu hash aquí",
  "enter_text": "Ingresa tu texto aquí",
  "decrypt": "Desencriptar",
  "encrypt": "Encriptar",
  "copy": "Copiar",
  "save_text": "Guardar texto",
  "save_text_info": "Error al guardar el texto",
  "store_in_file": "Almacenar en archivo",
  "empty_text": "Texto vacío",
  "empty_text_info": "Por favor, proporciona tu texto",
  "about": "Acerca de",
  "purpose": "Propósito de la Aplicación:",
  "purpose_info":
      "Esta aplicación tiene como único propósito ofrecer funcionalidades de cifrado y descifrado de contraseñas relacionadas con carteras de Bitcoin o cualquier texto.",
  "functionalities": "Funcionalidades Clave:",
  "functionalities_info":
      "La aplicación te permite cifrar las contraseñas de tu cartera de Bitcoin para mayor seguridad. Ofrece la funcionalidad de descifrar carteras de Bitcoin o cualquier texto previamente cifrado.",
  "internet": "Acceso a Internet:",
  "internet_info":
      "Esta aplicación no requiere acceso a Internet para sus funcionalidades. No se transmite información por Internet durante el proceso de cifrado o descifrado.",
  "open_source": "Código Fuente Abierto:",
  "open_source_info":
      "Esta aplicación es un software de código abierto, lo que significa que el código fuente está disponible públicamente. Alentamos a los usuarios a revisar el código para mayor transparencia y confianza.",
  "responsibilities": "Responsabilidades del Usuario:",
  "responsibilities_info":
      "Los usuarios son responsables de mantener la confidencialidad de sus contraseñas e información relacionada con la cartera de Bitcoin o cualquier texto. Recomendamos el uso de contraseñas fuertes y prácticas de seguridad adecuadas.",
  "password_loss": "Recuperación de Contraseña:",
  "password_loss_info":
      "Es importante tener en cuenta que, en caso de pérdida de la contraseña, no hay forma de recuperar las claves de tu cartera de Bitcoin o cualquier texto cifrado.",
  "created_flutter":
      "Esta aplicación fue desarrollada utilizando el marco de trabajo Flutter.",
  "created_flutter_info":
      "Desarrollada en Flutter, esta aplicación incorpora funcionalidades de cifrado a través de las bibliotecas encrypt.dart y cryptography.dart.",
  "generate_keyword_btc":
      "Genera tus palabras clave para una cartera de Bitcoin.",
  "choose_number":
      "Seleccione entre 12 o 24 palabras para su frase mnemotécnica.",
  "12words": "12 palabras",
  "24words": "24 palabras",
  "phrase": "Frase mnemotécnica",
  "generate_words": "Generar palabras",
  "terms":
      "Al utilizar esta aplicación, aceptas nuestra política de privacidad",
};
