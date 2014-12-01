#!/usr/bin/env python2

import sys
import os
import pygame

KEY_A       = pygame.K_RETURN
KEY_B       = pygame.K_QUOTE
KEY_START   = pygame.K_SPACE
KEY_SELECT  = pygame.K_e
KEY_UP      = pygame.K_w
KEY_DOWN    = pygame.K_s
KEY_LEFT    = pygame.K_a
KEY_RIGHT   = pygame.K_d

def main():
    assert len(sys.argv) == 2
    
    with open(sys.argv[1], 'wb') as output:
        pygame.init()
        pygame.display.set_mode((256,256))
        pygame.display.set_caption("Input Here")

        print "Waiting for Input"

        prev_mask = 0

        while True:
            pygame.event.pump()
            keys = pygame.key.get_pressed()

            mask = 0

            if keys[KEY_A]:      mask |= 0x01
            if keys[KEY_B]:      mask |= 0x02
            if keys[KEY_SELECT]: mask |= 0x04
            if keys[KEY_START]:  mask |= 0x08
            if keys[KEY_RIGHT]:  mask |= 0x10
            if keys[KEY_LEFT]:   mask |= 0x20
            if keys[KEY_UP]:     mask |= 0x40
            if keys[KEY_DOWN]:   mask |= 0x80

            if mask != prev_mask:
                output.write(chr(mask))
                output.flush()
                prev_mask = mask


if __name__=="__main__":
    main()
