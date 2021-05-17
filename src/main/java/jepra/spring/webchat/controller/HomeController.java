package jepra.spring.webchat.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import jepra.spring.webchat.model.Chat;
import jepra.spring.webchat.service.Response;


@Controller
public class HomeController {

    @RequestMapping(value = "/")
    public String home(){
        return "home";
    }

    @MessageMapping("/chat")
    @SendTo("/topic/chatting")
    public Response chatting(Chat message) throws Exception {
        return new Response(message.getChat());
    }
}

