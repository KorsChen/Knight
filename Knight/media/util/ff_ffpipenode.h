/*
 * ff_ffpipenode.h
 *
 * Copyright (c) 2014 Bilibili
 * Copyright (c) 2014 Zhang Rui <bbcallen@gmail.com>
 *
 * This file is part of ijkPlayer.
 *
 * ijkPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ijkPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ijkPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#ifndef FFPLAY__FF_FFPIPENODE_H
#define FFPLAY__FF_FFPIPENODE_H

#include "ijksdl_mutex.h"

typedef struct KFF_Pipenode_Opaque KFF_Pipenode_Opaque;
typedef struct KFF_Pipenode KFF_Pipenode;
struct KFF_Pipenode {
    SDL_mutex *mutex;
    void *opaque;

    void (*func_destroy) (KFF_Pipenode *node);
    int  (*func_run_sync)(KFF_Pipenode *node);
    int  (*func_flush)   (KFF_Pipenode *node); // optional
};

KFF_Pipenode *ffpipenode_alloc(size_t opaque_size);
void ffpipenode_free(KFF_Pipenode *node);
void ffpipenode_free_p(KFF_Pipenode **node);

int  ffpipenode_run_sync(KFF_Pipenode *node);
int  ffpipenode_flush(KFF_Pipenode *node);

#endif
